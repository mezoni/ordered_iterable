import 'src/comparer.dart';
import 'src/ordered_iterable.dart';

export 'src/comparer.dart';

/// The [OrderedIterableExtension] extension implements functionality that
/// supports multiple additional sorting using different keys.
///
/// The following methods are available for sorting:
///
/// - orderBy
/// - orderByDescending
/// - thenBy
/// - thenByDescending
extension OrderedIterableExtension<E> on Iterable<E> {
  /// Performs a sort on this collection by the key returned by the
  /// [keySelector] function in ascending order.
  OrderedIterable<E> orderBy<TKey>(TKey Function(E) keySelector,
      [Comparer<TKey>? comparer]) {
    return OrderedIterable(this)
      ..addOrdering(
          comparer: comparer, descending: false, keySelector: keySelector);
  }

  /// Performs a sort on this collection by the key returned by the
  /// [keySelector] function in descending order.
  OrderedIterable<E> orderByDescending<TKey>(TKey Function(E) keySelector,
      [Comparer<TKey>? comparer]) {
    return OrderedIterable(this)
      ..addOrdering(
          comparer: comparer, descending: true, keySelector: keySelector);
  }
}
