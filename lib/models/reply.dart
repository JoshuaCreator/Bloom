class Reply {
  final String message, replySenderId, toMessageId, toSenderId;
  final String? id;
  final bool? isMe, pending;
  final DateTime time;
  final List? likes;

  Reply({
    this.id,
    required this.message,
    required this.replySenderId,
    required this.toMessageId,
    required this.toSenderId,
    this.isMe,
    this.pending,
    required this.time,
    this.likes,
  });
}
