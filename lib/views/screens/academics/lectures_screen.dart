import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class LecturesScreen extends StatelessWidget {
  static String id = 'lectures';
  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final String dateTime =
    //     DateFormat('E d MMM y\t\t\t\th:mm a').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Lectures')),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: const [
          // Text(dateTime),
        ],
      ),
    );
  }
}
