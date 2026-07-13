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
  int? _requestedTab;

  AppUser? get user => _user;
  bool get isBusy => _busy;
  String? get error => _error;
  int? get requestedTab => _requestedTab;
  bool get isLoggedIn => _auth.currentUser != null && _user != null;

  Future<void> init() async {
    await _firestore.seedDemoOpportunitiesIfEmpty();
    await _ensureAdminAccount();

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = await _firestore.getUser(firebaseUser.uid);
      notifyListeners();
    }
  }

  Future<void> _ensureAdminAccount() async {
    const email = FirestoreService.adminEmail;
    const password = 'Admin@1234';

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.createUser(AppUser(
        id: cred.user!.uid,
        name: 'Eloi Buyange',
        email: email,
        role: UserRole.admin,
        createdAt: DateTime.now(),
      ));
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          final cred = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _firestore.ensureAdminProfile(cred.user!.uid);
          await _auth.signOut();
        } catch (_) {}
      }
    }
  }

  void requestTab(int index) {
    _requestedTab = index;
    notifyListeners();
  }

  void clearTabRequest() {
    _requestedTab = null;
  }

  Future<void> refreshUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    _user = await _firestore.getUser(uid);
    notifyListeners();
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

      final ratings = {for (final s in skills) s: 70};

      final profile = AppUser(
        id: cred.user!.uid,
        name: name.trim(),
        email: email.trim(),
        role: UserRole.student,
        skills: skills,
        skillRatings: ratings,
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

  Future<void> updateProfile({
    String? name,
    String? bio,
    String? location,
    String? startupName,
    List<String>? skills,
    Map<String, int>? skillRatings,
  }) async {
    if (_user == null) return;
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (bio != null) data['bio'] = bio;
    if (location != null) data['location'] = location;
    if (startupName != null) data['startupName'] = startupName;
    if (skills != null) data['skills'] = skills;
    if (skillRatings != null) data['skillRatings'] = skillRatings;

    await _firestore.updateUser(_user!.id, data);
    _user = _user!.copyWith(
      name: name,
      bio: bio,
      location: location,
      startupName: startupName,
      skills: skills,
      skillRatings: skillRatings,
    );
    notifyListeners();
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null || _user == null) {
      throw StateError('Not signed in.');
    }
    final cred = EmailAuthProvider.credential(
      email: _user!.email,
      password: currentPassword,
    );
    await firebaseUser.reauthenticateWithCredential(cred);
    await firebaseUser.updatePassword(newPassword);
  }

  Future<void> setSkillRating(String skill, int rating) async {
    if (_user == null) return;
    final ratings = Map<String, int>.from(_user!.skillRatings);
    ratings[skill] = rating.clamp(0, 100);
    final skills = _user!.skills.contains(skill)
        ? _user!.skills
        : [..._user!.skills, skill];
    await updateProfile(skillRatings: ratings, skills: skills);
  }

  Future<void> applyToJob(JobPosting job) async {
    if (_user == null) throw StateError('Not signed in');
    final score = computeMatchScore(_user!.skillRatings, job.skills);
    await _firestore.submitApplication(
      student: _user!,
      job: job,
      matchScore: score,
    );
  }

  Future<void> withdrawApplication(String applicationId) async {
    await _firestore.withdrawApplication(applicationId);
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
