class Tuple2<T1, T2> {
  const Tuple2(this.item1, this.item2);

  final T1 item1;
  final T2 item2;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Tuple2<T1, T2> &&
            other.item1 == item1 &&
            other.item2 == item2;
  }

  @override
  int get hashCode => Object.hash(item1, item2);

  @override
  String toString() => 'Tuple2($item1, $item2)';
}
