class JobPosting {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type; // Remote, On-site, Hybrid
  final int applicantCount;
  final bool isActive;
  final int matchScore;
  final List<String> skills;
  final String salary;
  final String postedDate;
  final bool isVerified;

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
  });
}

class Applicant {
  final String id;
  final String name;
  final String university;
  final String jobApplied;
  final int matchScore;
  final String status; // New, Shortlisted, Interviewing, Rejected
  final String avatarUrl;

  const Applicant({
    required this.id,
    required this.name,
    required this.university,
    required this.jobApplied,
    required this.matchScore,
    required this.status,
    required this.avatarUrl,
  });
}

class Application {
  final String id;
  final String jobTitle;
  final String company;
  final String status; // Applied, Viewed, Interview, Accepted, Rejected
  final String appliedDate;
  final int matchScore;

  const Application({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedDate,
    required this.matchScore,
  });
}

class UserProfile {
  final String name;
  final String role; // student | founder
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
