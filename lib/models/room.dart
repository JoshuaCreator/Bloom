class Room {
  final String name, creator, creatorId;
  final String? id, desc, image;
  final DateTime? createdAt;
  final bool private;
  final List? participants;

  Room({
    required this.name,
    required this.creator,
    required this.creatorId,
    this.id,
    this.desc,
    this.image,
    this.createdAt,
    required this.private,
    this.participants,
  });
}
