import 'package:collection/collection.dart';

import 'comparer.dart';

/// The [OrderedIterable] class implements the functionality of an [Iterable]
/// sorted by a specific key.
class OrderedIterable<TElement> with Iterable<TElement> {
  final List<_Ordering<TElement, Object?>> _orderings = [];

  final Iterable<TElement> _source;

  OrderedIterable(Iterable<TElement> source) : _source = source;

  @override
  Iterator<TElement> get iterator {
    return _getIterator();
  }

  /// Adds another sorting level criteria and parameters.
  void addOrdering<TKey>(
      {Comparer<TKey>? comparer,
      required bool descending,
      required TKey Function(TElement) keySelector}) {
    final ordering = _Ordering<TElement, TKey>(
        comparer: comparer, descending: descending, keySelector: keySelector);
    _orderings.add(ordering);
  }

  /// Performs an additional sort on this collection by the key returned by the
  /// [keySelector] function in ascending order.
  OrderedIterable<TElement> thenBy<TKey>(TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]) {
    addOrdering(
        comparer: comparer, descending: false, keySelector: keySelector);
    return this;
  }

  /// Performs an additional sort on this collection by the key returned by the
  /// [keySelector] function in descending order.
  OrderedIterable<TElement> thenByDescending<TKey>(
      TKey Function(TElement) keySelector,
      [Comparer<TKey>? comparer]) {
    addOrdering(comparer: comparer, descending: true, keySelector: keySelector);
    return this;
  }

  Iterator<TElement> _getIterator() {
    final list = _source.toList();
    if (list.length < 2) {
      return list.iterator;
    }

    if (_orderings.isEmpty) {
      return list.iterator;
    }

    // Also known as a group list.
    var input = [list];
    // The same list as input.
    var output = <List<TElement>>[];
    for (var index = 0; index < _orderings.length; index++) {
      final ordering = _orderings[index];
      final comparer = ordering.comparer;
      final descending = ordering.descending;
      final keySelector = ordering.keySelector;
      final Comparator<TElement> compare;
      if (descending) {
        compare = (TElement a, TElement b) =>
            comparer.compare(keySelector(b), keySelector(a));
      } else {
        compare = (TElement a, TElement b) =>
            comparer.compare(keySelector(a), keySelector(b));
      }

      for (var i = 0; i < input.length; i++) {
        final group = input[i];
        final length = group.length;
        if (length < 2) {
          // Nothing
        } else if (length == 2) {
          final a = group[0];
          final b = group[1];
          final x = compare(a, b);
          if (x < 0) {
            group[0] = a;
            group[1] = b;
          } else if (x > 0) {
            group[0] = b;
            group[1] = a;
          }
        } else {
          mergeSort(group, start: 0, compare: compare);
        }
      }

      if (index == _orderings.length - 1) {
        output = input;
      } else {
        output = [];
        for (var i = 0; i < input.length; i++) {
          final group = input[i];
          if (group.isEmpty) {
            continue;
          }

          var previous = group[0];
          // Create new group.
          var newGroup = [previous];
          // Start processing current group.
          output.add(newGroup);
          for (var j = 1; j < group.length; j++) {
            final element = group[j];
            if (compare(element, previous) == 0) {
              // An element from the current group.
              newGroup.add(element);
            } else {
              // An element from another group.
              // Switching to processing this group.
              newGroup = [element];
              output.add(newGroup);
            }

            previous = element;
          }
        }

        // Now the output data becomes the input for the next stage of sorting.
        input = output;
      }
    }

    final result = <TElement>[];
    // Transform elements from all groups into a flat list.
    for (var i = 0; i < output.length; i++) {
      result.addAll(output[i]);
    }

    return result.iterator;
  }
}

class _Ordering<TElement, TKey> {
  final Comparer<TKey> comparer;

  final bool descending;

  final TKey Function(TElement) keySelector;

  _Ordering(
      {Comparer<TKey>? comparer,
      required this.descending,
      required this.keySelector})
      : comparer = comparer ?? Comparer.getDefault();
}
