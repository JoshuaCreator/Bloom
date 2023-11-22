class Workspace {
  final String name;
  final String? id, desc, creatorId;
  final List? participants;
  final List? rooms;
  final DateTime createdAt;

  Workspace({
    this.id,
    required this.name,
    this.desc,
    this.creatorId,
    this.participants,
    this.rooms,
    required this.createdAt,
  });
}
