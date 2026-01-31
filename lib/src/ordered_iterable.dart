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
    return _order().iterator;
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

  List<TElement> _order() {
    final List<TElement> result;
    if (parent != null) {
      result = parent!._order();
    } else {
      result = source.toList();
    }

    final Comparator<TElement> comparator;
    if (descending) {
      comparator = (TElement a, TElement b) =>
          -comparer.compare(keySelector(a), keySelector(b));
    } else {
      comparator = (TElement a, TElement b) =>
          comparer.compare(keySelector(a), keySelector(b));
    }

    final sorter = SymmergeSorter<TElement>(comparator);
    sorter.sort(result);
    return result;
  }
}
