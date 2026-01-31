import 'package:ordered_iterable/ordered_iterable.dart';

void main() {
  _orderFruitsAndVegetablesByTypeThenByNameDescending();
  _orderPersonsByNameThenByAgeDescending();
}

void _orderFruitsAndVegetablesByTypeThenByNameDescending() {
  const source = [
    ('fruit', 'banana'),
    ('vegetables', 'spinach'),
    ('fruit', 'mango'),
    ('vegetables', 'cucumbers'),
    ('fruit', 'apple'),
    ('vegetables', 'potato'),
  ];
  final result = source.orderBy((x) => x.$1).thenByDescending((x) => x.$2);
  _print(source);
  _print(result);
}

void _orderPersonsByNameThenByAgeDescending() {
  final source = [
    _Person('Jarry', 19),
    _Person('Jarry', 22),
    _Person('John', 20),
    null,
    _Person('Jack', 21),
  ];
  final byName = Comparer.create<_Person>((a, b) => a.name.compareTo(b.name));
  final byAge = Comparer.create<_Person>((a, b) => a.age.compareTo(b.age));
  final result =
      source.orderBy((x) => x, byName).thenByDescending((x) => x, byAge);
  _print(source);
  _print(result);
}

void _print<E>(Iterable<E> collection) {
  print('-' * 40);
  for (final element in collection) {
    print(element);
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
