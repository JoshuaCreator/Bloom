class Department {
  final String name;
  final String? id, desc, creatorId;
  final List? participants;
  final DateTime createdAt;

  Department({
    this.id,
    required this.name,
    this.desc,
    this.creatorId,
    this.participants,
    required this.createdAt,
  });
}
