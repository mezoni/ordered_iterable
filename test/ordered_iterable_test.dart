import 'package:ordered_iterable/ordered_iterable.dart';
import 'package:test/test.dart';

void main() {
  _test();
}

void _test() {
  {
    test('orderBy()', () {
      final source = [
        (1, 'A'),
        (3, 'C'),
        (2, 'B'),
        (5, 'E'),
        (4, 'D'),
      ];

      final result = source.orderBy((x) => x.$1);
      expect(result, [
        (1, 'A'),
        (2, 'B'),
        (3, 'C'),
        (4, 'D'),
        (5, 'E'),
      ]);
    });
  }

  {
    test('orderByDescending()', () {
      final source = [
        (1, 'A'),
        (3, 'C'),
        (2, 'B'),
        (5, 'E'),
        (4, 'D'),
      ];

      final result = source.orderByDescending((x) => x.$1);
      expect(result, [
        (5, 'E'),
        (4, 'D'),
        (3, 'C'),
        (2, 'B'),
        (1, 'A'),
      ]);
    });
  }

  {
    test('thenBy()', () {
      final source = [
        ('fruit', 'banana'),
        ('vegetables', 'spinach'),
        ('fruit', 'mango'),
        ('vegetables', 'cucumbers'),
        ('fruit', 'apple'),
        ('vegetables', 'potato'),
      ];

      final result = source.orderBy((x) => x.$2).thenBy((x) => x.$1);
      expect(result, [
        ('fruit', 'apple'),
        ('fruit', 'banana'),
        ('fruit', 'mango'),
        ('vegetables', 'cucumbers'),
        ('vegetables', 'potato'),
        ('vegetables', 'spinach'),
      ]);
    });
  }

  {
    test('thenByDescending()', () {
      final source = [
        ('fruit', 'banana'),
        ('vegetables', 'spinach'),
        ('fruit', 'mango'),
        ('vegetables', 'cucumbers'),
        ('fruit', 'apple'),
        ('vegetables', 'potato'),
      ];

      final result = source.orderByDescending((x) => x.$2).thenBy((x) => x.$1);
      expect(result, [
        ('fruit', 'mango'),
        ('fruit', 'banana'),
        ('fruit', 'apple'),
        ('vegetables', 'spinach'),
        ('vegetables', 'potato'),
        ('vegetables', 'cucumbers'),
      ]);
    });
  }

  {
    test('Comparer of nullable values', () {
      final source = [
        _Person('Jarry', 22),
        _Person('John', 20),
        _Person('Jack', 21),
        null,
      ];

      final comparer =
          Comparer.create<_Person>((a, b) => a.name.compareTo(b.name));

      final result = source.orderBy((x) => x, comparer);
      expect(result, [
        null,
        _Person('Jack', 21),
        _Person('Jarry', 22),
        _Person('John', 20),
      ]);
    });
  }
}

class _Person {
  final int age;

  final String name;

  _Person(this.name, this.age);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is _Person) {
      return name == other.name && age == other.age;
    }

    return false;
  }

  @override
  String toString() {
    return '$name ($age)';
  }
}
