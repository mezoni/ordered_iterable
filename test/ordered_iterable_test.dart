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

      final result = source.orderBy((x) => x.$1).thenBy((x) => x.$2);
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

      final result = source.orderBy((x) => x.$1).thenByDescending((x) => x.$2);
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
    test('thenByDescending()', () {
      final source = [
        ('A', 1, 1),
        ('A', 1, 2),
        ('A', 2, 2),
        ('B', 3, 3),
        ('B', 3, 4),
        ('B', 4, 4),
      ];

      final result = source
          .orderByDescending((x) => x.$1)
          .thenByDescending((x) => x.$2)
          .thenByDescending((x) => x.$3);
      expect(result, [
        ('B', 4, 4),
        ('B', 3, 4),
        ('B', 3, 3),
        ('A', 2, 2),
        ('A', 1, 2),
        ('A', 1, 1),
      ]);
    });
  }

  {
    test('thenByDescending() bool', () {
      final source = [
        (false, false, false),
        (false, false, true),
        (false, true, false),
        (false, true, true),
        (true, false, false),
        (true, false, true),
        (true, true, false),
        (true, true, true),
      ];

      final result = source
          .orderByDescending((x) => x.$1)
          .thenByDescending((x) => x.$2)
          .thenByDescending((x) => x.$3);
      expect(result, [
        (true, true, true),
        (true, true, false),
        (true, false, true),
        (true, false, false),
        (false, true, true),
        (false, true, false),
        (false, false, true),
        (false, false, false),
      ]);
    });
  }

  {
    test('thenByDescending() String', () {
      final source = [
        ('false', 'false', 'false'),
        ('false', 'false', 'true'),
        ('false', 'true', 'false'),
        ('false', 'true', 'true'),
        ('true', 'false', 'false'),
        ('true', 'false', 'true'),
        ('true', 'true', 'false'),
        ('true', 'true', 'true'),
      ];

      final result = source
          .orderByDescending((x) => x.$1)
          .thenByDescending((x) => x.$2)
          .thenByDescending((x) => x.$3);
      expect(result, [
        ('true', 'true', 'true'),
        ('true', 'true', 'false'),
        ('true', 'false', 'true'),
        ('true', 'false', 'false'),
        ('false', 'true', 'true'),
        ('false', 'true', 'false'),
        ('false', 'false', 'true'),
        ('false', 'false', 'false'),
      ]);
    });
  }

  {
    test('thenByDescending() x 5', () {
      const count = 50;
      final source = <(int, int, int, int, int)>[];
      for (var i = 0; i < count; i++) {
        source.add((i, i, i, i, i));
      }

      final result = source
          .orderByDescending((x) => x.$1)
          .thenByDescending((x) => x.$2)
          .thenByDescending((x) => x.$3)
          .thenByDescending((x) => x.$4)
          .thenByDescending((x) => x.$5)
          .toList();

      final list = <(int, int, int, int, int)>[];
      for (var i = count - 1; i >= 0; i--) {
        list.add((i, i, i, i, i));
      }

      expect(
          result,
          List.generate(
              count,
              (i) => (
                    count - i - 1,
                    count - i - 1,
                    count - i - 1,
                    count - i - 1,
                    count - i - 1
                  )));
    });
  }

  {
    test('Comparer of nullable values', () {
      final source = [
        _Person('Jarry', 22),
        null,
        _Person('John', 20),
        _Person('Jack', 21),
        null,
      ];

      final comparer =
          Comparer.create<_Person>((a, b) => a.name.compareTo(b.name));

      final result = source.orderBy((x) => x, comparer);
      expect(result, [
        null,
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
