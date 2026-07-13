# InternBridge

A Flutter mobile app that connects **ALU students** with **student-led startups** for internships. Students discover opportunities, apply in one tap, and track applications. Founders post roles and review applicants. Admins verify startups before listings go live as **ALU Verified**.

Built as a final project for the ALU Flutter course — Firebase backend, Provider state management, role-based UX.

---

## Features

### Students
- Register and sign in with Firebase Auth
- Browse recommended internships on Home
- Search and filter matches (skills, remote, verified)
- Apply to opportunities (syncs to Firestore in real time)
- Track applications (active / past)
- Skill-based match score on each listing

### Founders / Startups
- Register with startup name (pending admin verification)
- Create and manage internship postings
- Toggle listings active / closed
- View applicants and shortlist candidates
- Startup profile with verification badge when approved

### Admins
- Review founder registration requests
- Approve or decline startups
- Approved startups get ALU Verified on their listings
- Dashboard and user management screens (partial UI)

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart 3.11+) |
| Backend | Firebase Authentication, Cloud Firestore |
| State management | [Provider](https://pub.dev/packages/provider) (`ChangeNotifier`) |
| UI | Material 3, custom theme |
| Config | FlutterFire CLI (`firebase_options.dart`) |

---

## Project Structure

```
lib/
├── main.dart                    # Firebase init, Provider root
├── firebase_options.dart
├── core/theme.dart              # AppColors, AppTheme
├── models/models.dart           # AppUser, JobPosting, Application, etc.
├── providers/app_provider.dart  # Auth session, user actions
├── services/firestore_service.dart
├── utils/app_helpers.dart
├── widgets/shared_widgets.dart
└── screens/
    ├── splash_screen.dart
    ├── auth/                    # Login, register, role selection
    ├── student/                 # Home, matches, applications, profile
    ├── founder/                 # Home, postings, applicants, profile
    └── admin/                   # Dashboard, verification, users
```

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.11+)
- Android Studio or VS Code with Flutter extensions
- Android emulator or physical device (**required for grading** — web-only runs are not accepted)
- A [Firebase](https://console.firebase.google.com/) project

---

## Firebase Setup

1. Create a Firebase project (or use existing `internbridge-4b9be`).
2. Enable **Authentication → Email/Password**.
3. Create a **Cloud Firestore** database (test mode is fine for development).
4. Add an Android app with package name `com.example.internbridge`.
5. Download `google-services.json` and place it in `android/app/`.
6. If needed, regenerate Flutter config:
   ```bash
   flutterfire configure
   ```

On first launch, the app seeds **3 sample internships** if the `opportunities` collection is empty.

### Firestore Collections

| Collection | Purpose |
|------------|---------|
| `users` | Profiles (student, founder, admin), verification status |
| `opportunities` | Internship listings |
| `applications` | Student applications to roles |

See the full schema in [`docs/StudentName_FinalFlutterProject.md`](docs/StudentName_FinalFlutterProject.md).

---

## Getting Started

```bash
# Clone the repository
git clone <your-repo-url>
cd internbridge

# Install dependencies
flutter pub get

# Run on Android emulator or device
flutter run
```

### Useful commands

```bash
flutter analyze    # Static analysis
flutter test       # Run unit tests
flutter build apk  # Release APK
```

---

## Demo Accounts (Suggested)

Create these during your demo video, or use your own:

| Role | How to access |
|------|----------------|
| **Student** | Sign up via **Student** registration |
| **Founder** | Sign up via **Founder** registration |
| **Admin** | Sign in with any account whose email contains `admin` |

After founder sign-up, log in as admin and approve the startup under **Startup Verification**.

---

## Architecture Overview

```
Screens (UI)
    ↓
AppProvider (auth, loading, apply/post actions)
    ↓
FirestoreService (CRUD, streams)
    ↓
Firebase Auth + Cloud Firestore
```

- **Provider** holds the signed-in user and orchestrates auth/actions.
- **StreamBuilder** on list screens listens to Firestore for real-time updates.
- **FirestoreService** keeps Firebase logic out of widgets.

---

## Testing

```bash
flutter test
```

Current tests cover model logic (e.g. skill match scoring). Manual testing checklist:

- [ ] Student register → user in Firebase Auth + Firestore
- [ ] Apply to job → `applications` doc created, count updates
- [ ] Founder sees applicant without refresh
- [ ] Admin approves startup → verified badge on postings
- [ ] Sign out works from profile screens

---

## Documentation

| Document | Description |
|----------|-------------|
| [`docs/StudentName_FinalFlutterProject.md`](docs/StudentName_FinalFlutterProject.md) | Full technical report (export to PDF for Canvas) |

Rename to `YourName_FinalFlutterProject.pdf` before submission.

---

## Known Limitations

- Bookmarks and some admin screens are UI placeholders
- No push notifications or in-app messaging yet
- iOS requires additional Firebase setup (`GoogleService-Info.plist`)
- Production Firestore security rules not included (use test mode for demo)

---

## Future Work

- Firebase Cloud Messaging for status updates
- Persisted bookmarks
- In-app messaging
- Stricter ALU email verification
- Firestore security rules by role
- Portfolio uploads via Firebase Storage

---

## Author

**[Your Name]** — African Leadership University

Final Flutter Project · July 2026

---

## License

This project was submitted as academic coursework at ALU. All rights reserved by the author.
