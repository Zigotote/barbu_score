extension MyString on String {
  /// Capitalizes the first letter of a String
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
