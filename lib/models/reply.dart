class Reply {
  final String message, replySenderId, toMessageId, toSenderId;
  final String? id;
  final DateTime time;

  Reply({
    this.id,
    required this.message,
    required this.replySenderId,
    // required this.replySenderName,
    required this.toMessageId,
    required this.toSenderId,
    required this.time,
  });
}
