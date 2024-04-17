import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DeletePostPage extends StatefulWidget {
  @override
  _DeletePostPageState createState() => _DeletePostPageState();
}

class _DeletePostPageState extends State<DeletePostPage> {
  String blogId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Post ID to delete:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: 'BLOG ID',
              ),
              onChanged: (value) {
                setState(() {
                  blogId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform the deletion here
                _deletePost(context);
              },
              
              child: const Text('Delete Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePost(BuildContext context) {
    if (blogId.isNotEmpty) {
      // Execute mutation to delete post with the entered ID
      final deletePostMutation = gql('''
      mutation deleteBlogPost(\$blogId: String!) {
        deleteBlog(blogId: \$blogId) {
          success
        }
      }
    ''');

      final MutationOptions options = MutationOptions(
        document: deletePostMutation,
        variables: {'blogId': blogId},
      );

      GraphQLClient client = GraphQLProvider.of(context).value;

      client.mutate(options).then((result) {
        if (result.hasException) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(result.exception.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Post deleted successfully
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Post deleted successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(
                          context); // Pop twice to go back to the previous page
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      // Display error message if the entered ID is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid ID'),
            content: const Text('Please enter a valid ID.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
