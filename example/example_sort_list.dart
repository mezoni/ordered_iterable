import 'package:ordered_iterable/ordered_iterable.dart';

void main(List<String> args) {
  final list = [
    (1, 1, 1),
    (2, 3, 3),
    (1, 1, 2),
    (2, 2, 1),
    (1, 2, 3),
    (2, 2, 2),
  ];
  final result = list
      .orderByDescending((x) => x.$1)
      .thenByDescending((x) => x.$2)
      .thenByDescending((x) => x.$3)
      .toList();

  _replace(result, list);
  for (final element in list) {
    print(element);
  }
}

void _replace<E>(List<E> src, List<E> dst) {
  final length = src.length;
  if (dst.length != length) {
    throw ArgumentError('The lengths of the lists are not equal');
  }

  for (var i = 0; i < length; i++) {
    dst[i] = src[i];
  }
}
