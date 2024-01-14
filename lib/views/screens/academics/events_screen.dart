import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  static String id = 'events';
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
    );
  }
}
