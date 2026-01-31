import 'dart:collection';

import 'comparer.dart';
import 'symmerge_sorter.dart';

/// The [OrderedIterable] class implements the functionality of an [Iterable]
/// sorted by a specific key.
abstract class OrderedIterable<TElement> implements Iterable<TElement> {
  /// Creates an instance of an [OrderedIterable].
  OrderedIterable<TElement> createOrderedIterable<TKey>(
      TKey Function(TElement) keySelector, bool descending,
      [Comparer<TKey>? comparer]);

  /// Performs an additional sort on this collection by the key returned by the
  /// [keySelector] function in ascending order.
  OrderedIterable<TElement> thenBy<TKey>(TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]);

  /// Performs an additional sort on this collection by the key returned by the
  /// [keySelector] function in descending order.
  OrderedIterable<TElement> thenByDescending<TKey>(
      TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]);
}

class OrderedIterableImpl<TElement, TSortKey>
    with IterableMixin<TElement>
    implements OrderedIterable<TElement> {
  final Comparer<TSortKey> comparer;

  final bool descending;

  final TSortKey Function(TElement) keySelector;

  final OrderedIterableImpl<TElement, Object?>? parent;

  final Iterable<TElement> source;

  OrderedIterableImpl(this.source, this.keySelector, this.descending,
      Comparer<TSortKey>? comparer, this.parent)
      : comparer = comparer ?? Comparer.getDefault<TSortKey>();

  @override
  Iterator<TElement> get iterator {
    return _orderAll().iterator;
  }

  @override
  OrderedIterable<TElement> createOrderedIterable<TKey>(
      TKey Function(TElement) keySelector, bool descending,
      [Comparer<TKey>? comparer]) {
    return OrderedIterableImpl<TElement, TKey>(
        source, keySelector, descending, comparer, this);
  }

  @override
  OrderedIterable<TElement> thenBy<TKey>(TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]) {
    return createOrderedIterable<TKey>(keySelector, false, comparer);
  }

  @override
  OrderedIterable<TElement> thenByDescending<TKey>(
      TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]) {
    return createOrderedIterable<TKey>(keySelector, true, comparer);
  }

  List<List<TElement>> _order(List<List<TElement>> data, bool lastLevel) {
    final result = <List<TElement>>[];
    Comparator<TElement> comparator;
    if (descending) {
      comparator = (TElement a, TElement b) =>
          -comparer.compare(keySelector(a), keySelector(b));
    } else {
      comparator = (TElement a, TElement b) =>
          comparer.compare(keySelector(a), keySelector(b));
    }

    final sorter = SymmergeSorter<TElement>(comparator);
    final numberOfParts = data.length;
    for (var i = 0; i < numberOfParts; i++) {
      final elements = data[i];
      sorter.sort(elements);
      if (lastLevel) {
        result.add(elements);
        continue;
      }

      final numberOfElements = elements.length;
      if (numberOfElements == 1) {
        result.add([elements[0]]);
        continue;
      }

      var previous = elements[0];
      var newElements = [previous];
      result.add(newElements);
      for (var j = 1; j < numberOfElements; j++) {
        final element = elements[j];
        if (comparator(element, previous) != 0) {
          newElements = <TElement>[];
          result.add(newElements);
        }

        newElements.add(element);
        previous = element;
      }
    }

    return result;
  }

  Iterable<TElement> _orderAll() sync* {
    final source = this.source.toList();
    if (source.isEmpty) {
      return;
    }

    var data = <List<TElement>>[];
    data.add(source);
    final queue = <OrderedIterableImpl<TElement, Object?>>[];
    OrderedIterableImpl<TElement, Object?>? sequence = this;
    while (sequence != null) {
      queue.add(sequence);
      sequence = sequence.parent;
    }

    for (var i = queue.length - 1; i >= 0; i--) {
      final sequence = queue[i];
      data = sequence._order(data, i == 0);
    }

    final numberOfParts = data.length;
    for (var i = 0; i < numberOfParts; i++) {
      final elements = data[i];
      final numberOfElements = elements.length;
      for (var j = 0; j < numberOfElements; j++) {
        yield elements[j];
      }
    }
  }
}
