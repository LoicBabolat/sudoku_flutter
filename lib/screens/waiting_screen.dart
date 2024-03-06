import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('SUDOKU',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    );
  }
}
