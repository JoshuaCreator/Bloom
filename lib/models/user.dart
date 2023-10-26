class AppUser {
  final String fName, lName;
  final String? userId, oName, title;
  final int phone;
  const AppUser({
    required this.fName,
    required this.lName,
    this.userId,
    this.oName,
    this.title,
    required this.phone,
  });
}
