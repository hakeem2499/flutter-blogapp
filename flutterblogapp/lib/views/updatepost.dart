import 'package:flutter/material.dart';
import 'package:flutterblogapp/views/UpdatePostFormPage.dart';

class UpdatePostPage extends StatefulWidget {
  const UpdatePostPage({super.key});

  @override
  _UpdatePostPageState createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  String BlogId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Post ID to update:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: ' BLOG ID',
              ),
              onChanged: (value) {
                setState(() {
                  BlogId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (BlogId.isNotEmpty) {
                  // Navigate to the page where the user can update the post with the entered ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePostFormPage(BlogId),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Invalid ID'),
                        content: const Text('Please enter a valid ID.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Update Post'),
            ),
          ],
        ),
      ),
    );
  }
}
