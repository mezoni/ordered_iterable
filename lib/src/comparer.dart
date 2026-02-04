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
    final typeHolder = _TypeHolder<T>();
    if (typeHolder is _TypeHolder<int>) {
      return _IntComparer() as Comparer<T>;
    }

    if (typeHolder is _TypeHolder<String>) {
      return _StringComparer() as Comparer<T>;
    }

    if (typeHolder is _TypeHolder<Comparable<T>> ||
        typeHolder is _TypeHolder<Comparable<num>>) {
      return _GenericComparer<T>(Comparable.compare as int Function(T, T));
    } else if (typeHolder is _TypeHolder<bool>) {
      return _BoolComparer() as Comparer<T>;
    }

    throw StateError('Unable to determine default comparer for <$T> type');
  }
}

class _BoolComparer implements Comparer<bool> {
  @override
  int compare(bool a, bool b) => !a && b
      ? -1
      : a && !b
          ? 1
          : 0;
}

class _GenericComparer<T> implements Comparer<T> {
  final Compare<T> _compare;

  _GenericComparer(Compare<T> compare) : _compare = compare;

  @override
  int compare(T? a, T? b) {
    if (a != null && b != null) {
      return _compare(a, b);
    }

    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else {
      return 1;
    }
  }
}

class _IntComparer implements Comparer<int> {
  @override
  int compare(int a, int b) => a < b
      ? -1
      : a == b
          ? 0
          : 1;
}

class _StringComparer implements Comparer<String> {
  @override
  int compare(String a, String b) {
    final len1 = a.length;
    final len2 = b.length;
    final len = (len1 < len2) ? len1 : len2;
    for (var i = 0; i < len; i++) {
      final c1 = a.codeUnitAt(i);
      final c2 = b.codeUnitAt(i);
      if (c1 < c2) {
        return -1;
      }

      if (c1 > c2) {
        return 1;
      }
    }

    return len1 < len2
        ? -1
        : len1 == len2
            ? 0
            : 1;
  }
}

class _TypeHolder<T> {
  //
}
