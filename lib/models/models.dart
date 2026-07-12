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
    this.verificationStatus = VerificationStatus.approved,
    required this.createdAt,
  });

  bool get isVerifiedFounder =>
      role != UserRole.founder ||
      verificationStatus == VerificationStatus.approved;

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _roleFromString(data['role']),
      startupName: data['startupName'],
      university: data['university'] ?? 'African Leadership University',
      skills: List<String>.from(data['skills'] ?? []),
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
        'verificationStatus': verificationStatus.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
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

  JobPosting copyWith({
    int? applicantCount,
    bool? isActive,
    int? matchScore,
  }) {
    return JobPosting(
      id: id,
      title: title,
      company: company,
      location: location,
      type: type,
      applicantCount: applicantCount ?? this.applicantCount,
      isActive: isActive ?? this.isActive,
      matchScore: matchScore ?? this.matchScore,
      skills: skills,
      salary: salary,
      postedDate: postedDate,
      isVerified: isVerified,
      founderId: founderId,
      description: description,
    );
  }
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
      status: data['status'] ?? 'New',
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

class UserProfile {
  final String name;
  final String role;
  final String university;
  final String title;
  final String location;
  final List<String> skills;
  final int profileStrength;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.role,
    required this.university,
    required this.title,
    required this.location,
    required this.skills,
    required this.profileStrength,
    required this.avatarUrl,
  });
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

int computeMatchScore(List<String> studentSkills, List<String> jobSkills) {
  if (jobSkills.isEmpty) return 72;
  if (studentSkills.isEmpty) return 65;

  final student = studentSkills.map((s) => s.toLowerCase()).toSet();
  final job = jobSkills.map((s) => s.toLowerCase()).toSet();
  final overlap = student.intersection(job).length;
  final score = 55 + ((overlap / job.length) * 45).round();
  return score.clamp(60, 98);
}
