/*
 * Symmerge sort based on
 * http://ak.hanyang.ac.kr/papers/esa2004.pdf *
 * Stable Minimum Storage Merging by Symmetric Comparisons
 * Pok-Son Kim and Arne Kutzner
 */
class SymmergeSorter<TSource> {
  Comparator<TSource> comparator;

  SymmergeSorter(this.comparator);

  void sort(List<TSource> a) {
    _symmsort(a, 0, a.length);
  }

  void _pswap(List<TSource> a, int index, int f, int t, int l) {
    for (l += f; f < l; f++, t++) {
      final temp = a[index + f];
      a[index + f] = a[index + t];
      a[index + t] = temp;
    }
  }

  void _rotate(List<TSource> a, int l, int r, int end) {
    final n = end - l;
    final dist = r - l;
    if (dist == 0 || dist == n) {
      return;
    }

    int i, j, p;
    i = p = dist;
    j = n - p;
    while (i != j) {
      if (i > j) {
        _pswap(a, l, p - i, p, j);
        i -= j;
      } else {
        _pswap(a, l, p - i, p + j - i, i);
        j -= i;
      }
    }

    _pswap(a, l, p - i, p, i);
  }

  void _symmerge(List<TSource> a, int first1, int first2, int last) {
    if (first1 < first2 && first2 < last) {
      final m = (first1 + last) ~/ 2;
      final n = m + first2;
      int start;
      if (first2 > m) {
        var l = n - last;
        var r = m;
        final p = n - 1;
        int mid;
        while (l < r) {
          mid = (l + r) >> 1;
          if (comparator(a[mid], a[p - mid]) <= 0) {
            l = mid + 1;
          } else {
            r = mid;
          }
        }

        start = l;
      } else {
        var l = first1;
        var r = first2;
        final p = n - 1;
        int mid;
        while (l < r) {
          mid = (l + r) >> 1;
          if (comparator(a[mid], a[p - mid]) <= 0) {
            l = mid + 1;
          } else {
            r = mid;
          }
        }

        start = l;
      }

      final end = n - start;
      _rotate(a, start, first2, end);
      _symmerge(a, first1, start, m);
      _symmerge(a, m, end, last);
    }
  }

  void _symmsort(List<TSource> a, int f, int n) {
    if (n - f > 1) {
      final m = (f + n) >> 1;
      _symmsort(a, f, m);
      _symmsort(a, m, n);
      _symmerge(a, f, m, n);
    }
  }
}
