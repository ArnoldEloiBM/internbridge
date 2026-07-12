import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/firestore_service.dart';

class AppProvider extends ChangeNotifier {
  AppProvider({FirestoreService? firestore})
      : _firestore = firestore ?? FirestoreService();

  final FirestoreService _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _user;
  bool _busy = false;
  String? _error;

  AppUser? get user => _user;
  bool get isBusy => _busy;
  String? get error => _error;
  bool get isLoggedIn => _auth.currentUser != null && _user != null;

  Future<void> init() async {
    await _firestore.seedDemoOpportunitiesIfEmpty();
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = await _firestore.getUser(firebaseUser.uid);
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _setBusy(true);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _user = await _firestore.getUser(cred.user!.uid);
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _authMessage(e);
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> registerStudent({
    required String name,
    required String email,
    required String password,
    List<String> skills = const ['Flutter', 'Teamwork'],
  }) async {
    _setBusy(true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final profile = AppUser(
        id: cred.user!.uid,
        name: name.trim(),
        email: email.trim(),
        role: UserRole.student,
        skills: skills,
        createdAt: DateTime.now(),
      );

      await _firestore.createUser(profile);
      _user = profile;
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _authMessage(e);
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> registerFounder({
    required String name,
    required String startupName,
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final profile = AppUser(
        id: cred.user!.uid,
        name: name.trim(),
        email: email.trim(),
        role: UserRole.founder,
        startupName: startupName.trim(),
        verificationStatus: VerificationStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore.createUser(profile);
      _user = profile;
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _authMessage(e);
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> applyToJob(JobPosting job) async {
    if (_user == null) throw StateError('Not signed in');
    final score = computeMatchScore(_user!.skills, job.skills);
    await _firestore.submitApplication(
      student: _user!,
      job: job,
      matchScore: score,
    );
  }

  Future<void> createPosting({
    required String title,
    required String location,
    required String type,
    required String salary,
    required List<String> skills,
    String? description,
  }) async {
    if (_user == null || _user!.role != UserRole.founder) {
      throw StateError('Only founders can post opportunities.');
    }

    final job = JobPosting(
      id: '',
      title: title,
      company: _user!.startupName ?? _user!.name,
      location: location,
      type: type,
      applicantCount: 0,
      isActive: true,
      matchScore: 0,
      skills: skills,
      salary: salary,
      postedDate: 'Today',
      isVerified: _user!.verificationStatus == VerificationStatus.approved,
      founderId: _user!.id,
      description: description,
    );

    await _firestore.createOpportunity(job);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  FirestoreService get db => _firestore;

  void _setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'That email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
