class Workspace {
  final String name;
  final String? id, desc, image, creatorId;
  final List? participants;
  final List? rooms;
  final DateTime createdAt;
  final bool private;

  Workspace({
    this.id,
    required this.name,
    this.desc,
    this.image,
    this.creatorId,
    this.participants,
    this.rooms,
    required this.createdAt,
    required this.private,
  });
}
