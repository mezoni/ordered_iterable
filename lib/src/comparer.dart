typedef Compare<T> = int Function(T a, T b);

/// The [Comparer] class implements functionality that allows sorting
/// collections with nullable values ​​and that do not implement the
/// [Comparable] interface.
abstract class Comparer<T> {
  /// Compares the value of [a] and [b] in the same way as it is implemented
  /// in the [Comparable.compare].
  int compare(T a, T b);

  /// Creates a [Comparer] for the specified type [T] using the comparison
  /// function [compare].
  static Comparer<T> create<T>(Compare<T> compare) {
    return _GenericComparer<T>(compare);
  }

  /// Creates default [Comparer] for the specified type [T].
  ///
  /// The type can be `Comparable<T>`, `Comparable<num>`, or [bool].
  ///
  /// Otherwise, an exception is thrown..
  static Comparer<T> getDefault<T>() {
    final typeHolder = TypeHolder<T>();
    if (typeHolder is TypeHolder<Comparable<T>> ||
        typeHolder is TypeHolder<Comparable<num>>) {
      return _GenericComparer<T>(Comparable.compare as int Function(T, T));
    } else if (typeHolder is TypeHolder<bool>) {
      int compare(bool a, bool b) {
        if (a == b) {
          return 0;
        } else if (!a && b) {
          return -1;
        } else {
          return 1;
        }
      }

      return _GenericComparer<T>(compare as int Function(T, T));
    }

    throw StateError('Unable to determine default comparer');
  }
}

class TypeHolder<T> {
  //
}

class _GenericComparer<T> implements Comparer<T> {
  final Compare<T> _compare;

  _GenericComparer(Compare<T> compare) : _compare = compare;

  @override
  int compare(T? a, T? b) {
    if (a == null || b == null) {
      if (b == null && a == null) {
        return 0;
      }
      if (b == null) {
        return 1;
      }
      if (a == null) {
        return -1;
      }
    }

    return _compare(a, b);
  }
}
