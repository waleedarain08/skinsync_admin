extension ListUtils<T> on List<T> {
  T? firstWhereOrNull(bool Function(T item) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
