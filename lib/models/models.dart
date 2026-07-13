import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, founder, admin }

enum VerificationStatus { pending, approved, declined }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? startupName;
  final String university;
  final List<String> skills;
  final Map<String, int> skillRatings;
  final String bio;
  final String location;
  final VerificationStatus verificationStatus;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.startupName,
    this.university = 'African Leadership University',
    this.skills = const [],
    this.skillRatings = const {},
    this.bio = '',
    this.location = 'Kigali, Rwanda',
    this.verificationStatus = VerificationStatus.approved,
    required this.createdAt,
  });

  bool get isVerifiedFounder =>
      role != UserRole.founder ||
      verificationStatus == VerificationStatus.approved;

  int get profileStrength {
    if (skillRatings.isEmpty) return 60;
    final avg = skillRatings.values.reduce((a, b) => a + b) / skillRatings.length;
    return avg.round().clamp(50, 100);
  }

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ratingsRaw = data['skillRatings'] as Map<String, dynamic>? ?? {};
    final ratings = ratingsRaw.map((k, v) => MapEntry(k, (v as num).toInt()));

    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _roleFromString(data['role']),
      startupName: data['startupName'],
      university: data['university'] ?? 'African Leadership University',
      skills: List<String>.from(data['skills'] ?? []),
      skillRatings: ratings,
      bio: data['bio'] ?? '',
      location: data['location'] ?? 'Kigali, Rwanda',
      verificationStatus: _statusFromString(data['verificationStatus']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'role': role.name,
        if (startupName != null) 'startupName': startupName,
        'university': university,
        'skills': skills,
        'skillRatings': skillRatings,
        if (bio.isNotEmpty) 'bio': bio,
        'location': location,
        'verificationStatus': verificationStatus.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  AppUser copyWith({
    String? name,
    String? startupName,
    String? university,
    List<String>? skills,
    Map<String, int>? skillRatings,
    String? bio,
    String? location,
    VerificationStatus? verificationStatus,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      startupName: startupName ?? this.startupName,
      university: university ?? this.university,
      skills: skills ?? this.skills,
      skillRatings: skillRatings ?? this.skillRatings,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt,
    );
  }
}

class JobPosting {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final int applicantCount;
  final bool isActive;
  final int matchScore;
  final List<String> skills;
  final String salary;
  final String postedDate;
  final bool isVerified;
  final String? founderId;
  final String? description;

  const JobPosting({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.applicantCount,
    required this.isActive,
    required this.matchScore,
    required this.skills,
    required this.salary,
    required this.postedDate,
    required this.isVerified,
    this.founderId,
    this.description,
  });

  factory JobPosting.fromDoc(DocumentSnapshot doc, {int matchScore = 75}) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final created = (data['createdAt'] as Timestamp?)?.toDate();
    return JobPosting(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? 'Remote',
      type: data['type'] ?? 'Remote',
      applicantCount: data['applicantCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      matchScore: matchScore,
      skills: List<String>.from(data['skills'] ?? []),
      salary: data['salary'] ?? 'Stipend TBD',
      postedDate: _formatDate(created),
      isVerified: data['isVerified'] ?? false,
      founderId: data['founderId'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'company': company,
        'location': location,
        'type': type,
        'applicantCount': applicantCount,
        'isActive': isActive,
        'skills': skills,
        'salary': salary,
        'isVerified': isVerified,
        if (founderId != null) 'founderId': founderId,
        if (description != null) 'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      };
}

class Applicant {
  final String id;
  final String name;
  final String university;
  final String jobApplied;
  final int matchScore;
  final String status;
  final String avatarUrl;
  final String? studentId;
  final String? opportunityId;

  const Applicant({
    required this.id,
    required this.name,
    required this.university,
    required this.jobApplied,
    required this.matchScore,
    required this.status,
    required this.avatarUrl,
    this.studentId,
    this.opportunityId,
  });

  factory Applicant.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Applicant(
      id: doc.id,
      name: data['studentName'] ?? '',
      university: data['university'] ?? 'African Leadership University',
      jobApplied: data['jobTitle'] ?? '',
      matchScore: data['matchScore'] ?? 70,
      status: data['status'] ?? 'Applied',
      avatarUrl: '',
      studentId: data['studentId'],
      opportunityId: data['opportunityId'],
    );
  }
}

class Application {
  final String id;
  final String jobTitle;
  final String company;
  final String status;
  final String appliedDate;
  final int matchScore;
  final String? opportunityId;

  const Application({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedDate,
    required this.matchScore,
    this.opportunityId,
  });

  factory Application.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final applied = (data['appliedAt'] as Timestamp?)?.toDate();
    return Application(
      id: doc.id,
      jobTitle: data['jobTitle'] ?? '',
      company: data['company'] ?? '',
      status: data['status'] ?? 'Applied',
      appliedDate: _formatDate(applied),
      matchScore: data['matchScore'] ?? 70,
      opportunityId: data['opportunityId'],
    );
  }
}

UserRole _roleFromString(String? value) {
  switch (value) {
    case 'founder':
      return UserRole.founder;
    case 'admin':
      return UserRole.admin;
    default:
      return UserRole.student;
  }
}

VerificationStatus _statusFromString(String? value) {
  switch (value) {
    case 'approved':
      return VerificationStatus.approved;
    case 'declined':
      return VerificationStatus.declined;
    default:
      return VerificationStatus.pending;
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Recently';
  final now = DateTime.now();
  final diff = now.difference(date).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '${diff}d ago';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

/// Match score from self-rated skills vs job requirements.
int computeMatchScore(Map<String, int> skillRatings, List<String> jobSkills) {
  if (jobSkills.isEmpty) return 72;
  if (skillRatings.isEmpty) return 65;

  final ratings = <int>[];
  for (final jobSkill in jobSkills) {
    final key = skillRatings.keys.firstWhere(
      (k) => k.toLowerCase() == jobSkill.toLowerCase(),
      orElse: () => '',
    );
    if (key.isNotEmpty) ratings.add(skillRatings[key]!);
  }

  if (ratings.isEmpty) {
    // partial name overlap fallback
    for (final entry in skillRatings.entries) {
      for (final job in jobSkills) {
        if (entry.key.toLowerCase().contains(job.toLowerCase()) ||
            job.toLowerCase().contains(entry.key.toLowerCase())) {
          ratings.add(entry.value);
        }
      }
    }
  }

  if (ratings.isEmpty) return 65;
  final avg = ratings.reduce((a, b) => a + b) / ratings.length;
  return avg.round().clamp(60, 98);
}

int computeMatchScoreFromSkills(List<String> studentSkills, List<String> jobSkills) {
  final ratings = {for (final s in studentSkills) s: 75};
  return computeMatchScore(ratings, jobSkills);
}
