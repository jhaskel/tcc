import 'package:test/test.dart';
import 'counter.dart';

void main() {
  group('Counter', () {

    test('value should start at 0', () {
      expect(Counterl().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counterl();
      counter.increment();
      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counterl();
      counter.decrement();
      expect(counter.value, -1);
    });
  });
}
