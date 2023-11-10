class AppUser {
  // final String fName, lName;
  final String? userId, displayName, title;
  final int phone;
  const AppUser({
    // required this.fName,
    // required this.lName,
    this.userId,
    this.displayName,
    this.title,
    required this.phone,
  });
}
