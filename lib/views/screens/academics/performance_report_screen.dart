import 'package:flutter/material.dart';

class PerformanceReportScreen extends StatelessWidget {
  static String id = 'performance';
  const PerformanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance')),
    );
  }
}
