import 'package:flutter_test/flutter_test.dart';
import 'package:internbridge/models/models.dart';

void main() {
  test('skill ratings affect match score', () {
    final high = computeMatchScore(
      {'Flutter': 90, 'Dart': 85},
      ['Flutter', 'Dart'],
    );
    final low = computeMatchScore({}, ['Flutter', 'Dart']);

    expect(high, greaterThan(low));
    expect(high, inInclusiveRange(60, 98));
  });
}
