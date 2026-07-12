import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _opportunities =>
      _db.collection('opportunities');
  CollectionReference<Map<String, dynamic>> get _applications =>
      _db.collection('applications');

  Future<void> createUser(AppUser user) async {
    await _users.doc(user.id).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDoc(doc);
  }

  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDoc(doc);
    });
  }

  Stream<List<JobPosting>> watchOpportunities({List<String> studentSkills = const []}) {
    return _opportunities.snapshots().map((snap) {
      final docs = snap.docs.where((doc) => doc.data()['isActive'] == true).toList();
      docs.sort((a, b) {
        final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
      return docs
          .map((doc) => JobPosting.fromDoc(
                doc,
                matchScore: computeMatchScore(
                  studentSkills,
                  List<String>.from(
                    (doc.data()['skills'] as List?)?.cast<String>() ?? [],
                  ),
                ),
              ))
          .toList();
    });
  }

  Stream<List<JobPosting>> watchFounderOpportunities(String founderId) {
    return _opportunities
        .where('founderId', isEqualTo: founderId)
        .snapshots()
        .map((snap) {
      final docs = [...snap.docs];
      docs.sort((a, b) {
        final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
      return docs.map((doc) => JobPosting.fromDoc(doc)).toList();
    });
  }

  Future<String> createOpportunity(JobPosting job) async {
    final ref = await _opportunities.add(job.toMap());
    return ref.id;
  }

  Future<void> toggleOpportunity(String id, bool isActive) async {
    await _opportunities.doc(id).update({'isActive': isActive});
  }

  Stream<List<Application>> watchStudentApplications(String studentId) {
    return _applications
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snap) {
      final docs = [...snap.docs];
      docs.sort((a, b) {
        final aTime = (a.data()['appliedAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        final bTime = (b.data()['appliedAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
      return docs.map((doc) => Application.fromDoc(doc)).toList();
    });
  }

  Stream<List<Applicant>> watchFounderApplicants(String founderId) {
    return _applications
        .where('founderId', isEqualTo: founderId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((doc) => Applicant.fromDoc(doc)).toList();
      list.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      return list;
    });
  }

  Future<bool> hasApplied(String studentId, String opportunityId) async {
    final snap = await _applications
        .where('studentId', isEqualTo: studentId)
        .get();
    return snap.docs.any((doc) => doc.data()['opportunityId'] == opportunityId);
  }

  Future<void> submitApplication({
    required AppUser student,
    required JobPosting job,
    required int matchScore,
  }) async {
    final alreadyApplied = await hasApplied(student.id, job.id);
    if (alreadyApplied) {
      throw StateError('You already applied to this role.');
    }

    await _applications.add({
      'studentId': student.id,
      'studentName': student.name,
      'studentEmail': student.email,
      'university': student.university,
      'founderId': job.founderId,
      'opportunityId': job.id,
      'jobTitle': job.title,
      'company': job.company,
      'status': 'Applied',
      'matchScore': matchScore,
      'appliedAt': FieldValue.serverTimestamp(),
    });

    await _opportunities.doc(job.id).update({
      'applicantCount': FieldValue.increment(1),
    });
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    await _applications.doc(id).update({'status': status});
  }

  Stream<List<AppUser>> watchPendingFounders() {
    return _users
        .where('role', isEqualTo: 'founder')
        .where('verificationStatus', isEqualTo: 'pending')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => AppUser.fromDoc(doc)).toList());
  }

  Stream<List<AppUser>> watchAllFounders() {
    return _users
        .where('role', isEqualTo: 'founder')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => AppUser.fromDoc(doc)).toList());
  }

  Future<void> updateVerification(String uid, VerificationStatus status) async {
    await _users.doc(uid).update({'verificationStatus': status.name});
    if (status == VerificationStatus.approved) {
      // mark their listings as ALU verified once startup is approved
      final posts = await _opportunities
          .where('founderId', isEqualTo: uid)
          .get();
      for (final doc in posts.docs) {
        await doc.reference.update({'isVerified': true});
      }
    }
  }

  Future<void> seedDemoOpportunitiesIfEmpty() async {
    final existing = await _opportunities.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final samples = [
      {
        'title': 'Software Developer Intern',
        'company': 'NexGen Systems',
        'location': 'Remote',
        'type': 'Remote',
        'skills': ['React', 'Node.js', 'Git'],
        'salary': '\$800/mo',
        'isVerified': true,
      },
      {
        'title': 'Marketing Assistant',
        'company': 'GrowthHackers Co.',
        'location': 'Lagos, Nigeria',
        'type': 'Hybrid',
        'skills': ['Social Media', 'Content', 'Canva'],
        'salary': '\$600/mo',
        'isVerified': true,
      },
      {
        'title': 'UI Designer',
        'company': 'PixelPerfect Lab',
        'location': 'Kigali, Rwanda',
        'type': 'On-site',
        'skills': ['Figma', 'Design Ops', 'Prototyping'],
        'salary': '\$700/mo',
        'isVerified': true,
      },
    ];

    for (final sample in samples) {
      await _opportunities.add({
        ...sample,
        'applicantCount': 0,
        'isActive': true,
        'founderId': 'demo',
        'description': 'Hands-on internship with an ALU-affiliated startup.',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
