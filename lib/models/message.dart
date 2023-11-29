class Message {
  final String message, senderId;
  final String? id, image, file;
  final DateTime time;
  final bool? pending, me;
  final List? likes;

  const Message({
    this.id,
    required this.message,
    required this.senderId,
    this.image,
    this.file,
    required this.time,
    this.pending,
    this.me = false,
    this.likes,
  });
}
