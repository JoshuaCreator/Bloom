class Message {
  final String message, sender;
  final String? image;
  final DateTime time;

  const Message({
    required this.message,
    required this.sender,
    this.image,
    required this.time,
  });
}
