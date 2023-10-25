class AppUser {
  final String fName, lName;
  final String? oName, title;
  final int phone;
  const AppUser({
    required this.fName,
    required this.lName,
    this.oName,
    this.title,
    required this.phone,
  });
}
