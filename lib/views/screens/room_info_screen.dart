import 'package:flutter/material.dart';

class RoomInfoScreen extends StatelessWidget {
  static String id = 'room-info';
  const RoomInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room info')),
    );
  }
}
