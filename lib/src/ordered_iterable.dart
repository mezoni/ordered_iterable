import 'comparer.dart';
import 'symmerge_sorter.dart';

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
    final list = _source is List ? _source as List<TElement> : _source.toList();
    if (list.length < 2) {
      return list.iterator;
    }

    if (_orderings.isEmpty) {
      return list.iterator;
    }

    var input = [list];
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
        final elements = input[i];
        final sorter = SymmergeSorter(compare);
        sorter.sort(elements);
      }

      if (index == _orderings.length - 1) {
        output = input;
      } else {
        output = [];
        for (var i = 0; i < input.length; i++) {
          final elements = input[i];
          if (elements.isEmpty) {
            continue;
          }

          var previous = elements[0];
          var newElements = [previous];
          output.add(newElements);
          for (var j = 1; j < elements.length; j++) {
            final element = elements[j];
            if (compare(element, previous) == 0) {
              newElements.add(element);
            } else {
              newElements = [element];
              output.add(newElements);
            }

            previous = element;
          }
        }

        input = output;
      }
    }

    // Freeing up memory.
    input = [];

    Iterable<TElement> generate() sync* {
      for (var i = 0; i < output.length; i++) {
        final elements = output[i];
        for (var j = 0; j < elements.length; j++) {
          final element = elements[j];
          yield element;
        }
      }

      // Freeing up memory.
      output = input;
    }

    return generate().iterator;
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
