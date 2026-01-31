# Ordered iterable

Ordered iterable is a library for ordering collections (orderBy, orderByDescending, thenBy, thenByDescending).

Version: 1.0.2

[![Pub Package](https://img.shields.io/pub/v/ordered_iterable.svg)](https://pub.dev/packages/ordered_iterable)
[![Pub Monthly Downloads](https://img.shields.io/pub/dm/ordered_iterable.svg)](https://pub.dev/packages/ordered_iterable/score)
[![GitHub Issues](https://img.shields.io/github/issues/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/issues)
[![GitHub Forks](https://img.shields.io/github/forks/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/forks)
[![GitHub Stars](https://img.shields.io/github/stars/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/stargazers)
[![GitHub License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://raw.githubusercontent.com/mezoni/ordered_iterable/main/LICENSE)

- [Ordered iterable](#ordered-iterable)
  - [About this software](#about-this-software)
  - [Practical use](#practical-use)

## About this software

Ordered iterable is a library for ordering collections (orderBy, orderByDescending, thenBy, thenByDescending).  
It implements methods that allow to order (sort) collections more than once (use additional sorting).  

List of sorting methods:

- orderBy (Iterable)
- orderByDescending (Iterable)
- thenBy (OrderedIterable)
- thenByDescending (OrderedIterable)

## Practical use

A practical use is sorting collections with additional ordering.

Example:

```dart
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

```

**Output:**

```txt
----------------------------------------
(fruit, banana)
(vegetables, spinach)
(fruit, mango)
(vegetables, cucumbers)
(fruit, apple)
(vegetables, potato)
----------------------------------------
(fruit, mango)
(fruit, banana)
(fruit, apple)
(vegetables, spinach)
(vegetables, potato)
(vegetables, cucumbers)
----------------------------------------
Jarry (19)
Jarry (22)
John (20)
null
Jack (21)
----------------------------------------
null
Jack (21)
Jarry (22)
Jarry (19)
John (20)
```
