import 'dart:math';

import 'package:ordered_iterable/ordered_iterable.dart';

void main() {
  {
    final map = List.generate(100, (i) => i);
    final data = _generateData(map);
    _sort(data);
  }
  {
    final map = List.generate(
        100, (i) => '$i. The quick, brown fox jumps over a lazy dog.');
    final data = _generateData(map);
    _sort(data);
  }
}

List<(T, T, T)> _generateData<T>(List<T> map) {
  final r1 = Random(1);
  final r2 = Random(2);
  final r3 = Random(3);
  final data = <(T, T, T)>[];
  for (var i = 0; i < 100000; i++) {
    final e1 = map[r1.nextInt(100)];
    final e2 = map[r2.nextInt(100)];
    final e3 = map[r3.nextInt(100)];
    data.add((e1, e2, e3));
  }

  return data;
}

void _sort<T>(List<(T, T, T)> data) {
  final sw = Stopwatch();
  sw.start();
  // ignore: unused_local_variable
  final result = data
      .orderByDescending((x) => x.$1)
      .thenByDescending((x) => x.$2)
      .thenByDescending((x) => x.$3)
      .toList();
  sw.stop();
  print('-' * 40);
  print(
      "Sorting ${data.length} <${data.runtimeType}> elements (by 3 keys simultaneously) take ${sw.elapsedMilliseconds / 1000} s");
  print('First element: ${result.first}');
  print('Last element: ${result.last}');
}
