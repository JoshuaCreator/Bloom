class Message {
  final String message, sender;
  final String? id, image;
  final DateTime time;
  final bool? pending, isMe;
  final bool? previousMessageBySameSender;

  const Message({
     this.id,
    required this.message,
    required this.sender,
    this.image,
    required this.time,
    this.pending,
    this.isMe = false,
    this.previousMessageBySameSender,
  });
}
