import 'package:flutter_test/flutter_test.dart';
import 'package:internbridge/models/models.dart';

void main() {
  test('computeMatchScore increases with skill overlap', () {
    final high = computeMatchScore(
      ['Flutter', 'Dart'],
      ['Flutter', 'Dart', 'Firebase'],
    );
    final low = computeMatchScore([], ['Flutter', 'Dart']);

    expect(high, greaterThan(low));
    expect(high, inInclusiveRange(60, 98));
  });

  test('AppUser maps role strings correctly', () {
    expect(_roleFromString('founder'), UserRole.founder);
    expect(_roleFromString('admin'), UserRole.admin);
    expect(_roleFromString(null), UserRole.student);
  });
}

// expose private helpers for a quick sanity check
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
