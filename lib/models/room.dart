class Room {
  final String name, creatorId;
  final String? id, deptId, desc, image;
  final DateTime? createdAt;
  final bool private;
  final List participants;

  Room({
    required this.name,
    required this.creatorId,
    this.id,
    this.deptId,
    this.desc,
    this.image,
    this.createdAt,
    required this.private,
    required this.participants,
  });
}
