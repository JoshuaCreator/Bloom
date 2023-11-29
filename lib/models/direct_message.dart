class DirectMsg {
  final String message, fromId, toId;
  final String? id, image, file;
  final DateTime time;
  final bool? pending;
  final List<String>? participants;

  DirectMsg({
    required this.message,
    required this.fromId,
    required this.toId,
    this.id,
    this.image,
    this.file,
    required this.time,
    this.pending,
    this.participants,
  });
}
