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
