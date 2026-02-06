# Ordered iterable

Multi-level (by more than one key simultaneously), hierarchical, stable sorting of iterable collections (orderBy, orderByDescending, thenBy, thenByDescending).

Version: 1.0.10

[![Pub Package](https://img.shields.io/pub/v/ordered_iterable.svg)](https://pub.dev/packages/ordered_iterable)
[![Pub Monthly Downloads](https://img.shields.io/pub/dm/ordered_iterable.svg)](https://pub.dev/packages/ordered_iterable/score)
[![GitHub Issues](https://img.shields.io/github/issues/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/issues)
[![GitHub Forks](https://img.shields.io/github/forks/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/forks)
[![GitHub Stars](https://img.shields.io/github/stars/mezoni/ordered_iterable.svg)](https://github.com/mezoni/ordered_iterable/stargazers)
[![GitHub License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://raw.githubusercontent.com/mezoni/ordered_iterable/main/LICENSE)

- [Ordered iterable](#ordered-iterable)
  - [About this software](#about-this-software)
  - [Practical use](#practical-use)
  - [How to sort lists directly](#how-to-sort-lists-directly)

## About this software

Multi-level (by more than one key simultaneously), hierarchical, stable sorting of iterable collections (orderBy, orderByDescending, thenBy, thenByDescending).  

It implements methods that allows sorting collections by more than one key simultaneously.  
Hierarchical sorting defines a primary sort key, and subsequent keys (secondary, tertiary) sort the elements within previous higher-level groups.

List of sorting methods:

- orderBy (Iterable, primary)
- orderByDescending (Iterable, primary)
- thenBy (OrderedIterable, subsequent)
- thenByDescending (OrderedIterable, subsequent)

Sorting of data containing `null` is supported.  
Sorting of non-comparable data (data that does not implement the `Comparable` interface) is supported by using custom comparers.

## Practical use

A practical use is sorting collections with additional ordering.  

Example:

```dart
import 'package:ordered_iterable/ordered_iterable.dart';

void main() {
  _sortNumbersInDescendingOrder();
  _sortFruitsAndVegetablesByTypeThenByNameDescending();
  _sortOrdersByDateThenByStatusThenByAmountDescending();
  _sortPersonsByNameThenByAgeDescending();
}

DateTime _date(String date) {
  return DateTime.parse(date);
}

void _print<E>(Iterable<E> collection) {
  print('-' * 40);
  for (final element in collection) {
    print(element);
  }
}

void _sortFruitsAndVegetablesByTypeThenByNameDescending() {
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

void _sortNumbersInDescendingOrder() {
  const source = [
    (1, 1, 1),
    (2, 3, 3),
    (1, 1, 2),
    (2, 2, 1),
    (1, 2, 3),
    (2, 2, 2),
  ];
  final result = source
      .orderByDescending((x) => x.$1)
      .thenByDescending((x) => x.$2)
      .thenByDescending((x) => x.$3);
  _print(source);
  _print(result);
}

void _sortOrdersByDateThenByStatusThenByAmountDescending() {
  final orders = [
    (_date('20250102'), OrderStatus.shipped, 150.00),
    (_date('20250101'), OrderStatus.canceled, 100.00),
    (_date('20250102'), OrderStatus.shipped, 200.00),
    (_date('20250101'), OrderStatus.pending, 200.00),
    (_date('20250102'), OrderStatus.pending, 100.00),
    (_date('20250101'), OrderStatus.pending, 1000.00),
    (_date('20250102'), OrderStatus.pending, 1500.00),
  ];

  final byStatus =
      Comparer.create<OrderStatus>((a, b) => a.name.compareTo(b.name));
  final result = orders
      .orderBy((x) => x.$1)
      .thenBy((x) => x.$2, byStatus)
      .thenByDescending((x) => x.$3);
  _print(orders);
  _print(result);
}

void _sortPersonsByNameThenByAgeDescending() {
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

enum OrderStatus { canceled, created, pending, shipped }

class _Person {
  final int age;

  final String name;

  _Person(this.name, this.age);

  @override
  String toString() {
    return '$name ($age)';
  }
}

```

**Output:**

```txt
----------------------------------------
(1, 1, 1)
(2, 3, 3)
(1, 1, 2)
(2, 2, 1)
(1, 2, 3)
(2, 2, 2)
----------------------------------------
(2, 3, 3)
(2, 2, 2)
(2, 2, 1)
(1, 2, 3)
(1, 1, 2)
(1, 1, 1)
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
(2025-01-02 00:00:00.000, OrderStatus.shipped, 150.0)
(2025-01-01 00:00:00.000, OrderStatus.canceled, 100.0)
(2025-01-02 00:00:00.000, OrderStatus.shipped, 200.0)
(2025-01-01 00:00:00.000, OrderStatus.pending, 200.0)
(2025-01-02 00:00:00.000, OrderStatus.pending, 100.0)
(2025-01-01 00:00:00.000, OrderStatus.pending, 1000.0)
(2025-01-02 00:00:00.000, OrderStatus.pending, 1500.0)
----------------------------------------
(2025-01-01 00:00:00.000, OrderStatus.canceled, 100.0)
(2025-01-01 00:00:00.000, OrderStatus.pending, 1000.0)
(2025-01-01 00:00:00.000, OrderStatus.pending, 200.0)
(2025-01-02 00:00:00.000, OrderStatus.pending, 1500.0)
(2025-01-02 00:00:00.000, OrderStatus.pending, 100.0)
(2025-01-02 00:00:00.000, OrderStatus.shipped, 200.0)
(2025-01-02 00:00:00.000, OrderStatus.shipped, 150.0)
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

## How to sort lists directly

It's impossible to sort (by more than one key simultaneously) a list directly (in place).  
The reason is that the source data is divided into groups (uses hierarchy).  
That is, the sorting process creates a hierarchical list.  

However, sorting a list can be implemented using an intermediate list.  
Below is an example of how this can be implemented.

```dart
import 'package:ordered_iterable/ordered_iterable.dart';

void main(List<String> args) {
  final list = [
    (1, 1, 1),
    (2, 3, 3),
    (1, 1, 2),
    (2, 2, 1),
    (1, 2, 3),
    (2, 2, 2),
  ];
  final result = list
      .orderByDescending((x) => x.$1)
      .thenByDescending((x) => x.$2)
      .thenByDescending((x) => x.$3)
      .toList();

  _replace(result, list);
  for (final element in list) {
    print(element);
  }
}

void _replace<E>(List<E> src, List<E> dst) {
  final length = src.length;
  if (dst.length != length) {
    throw ArgumentError('The lengths of the lists are not equal');
  }

  for (var i = 0; i < length; i++) {
    dst[i] = src[i];
  }
}

```
