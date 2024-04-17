import 'package:flutter/material.dart';

class DisplayPageActivity extends StatelessWidget {
  const DisplayPageActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NewYorkTimes',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      body: Container(
        color: Colors.black, // Set body background color to black
        child: const Center(
          child: Text(
            'NewYorkTimes',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ),
    );
  }
}
