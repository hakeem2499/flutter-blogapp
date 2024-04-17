import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutterblogapp/views/updatepost.dart';

class UpdatePostFormPage extends StatefulWidget {
  final String blogId;

  const UpdatePostFormPage(this.blogId, {super.key});

  @override
  _UpdatePostFormPageState createState() => _UpdatePostFormPageState();
}

class _UpdatePostFormPageState extends State<UpdatePostFormPage> {
  String title = '';
  String subTitle = '';
  String body = '';
  get blogId => blogId.toString;

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
            Text(
              'Update Post with ID: ${widget.blogId}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Subtitle',
              ),
              onChanged: (value) {
                setState(() {
                  subTitle = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Body',
              ),
              onChanged: (value) {
                setState(() {
                  body = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform the update operation with the entered values
                _updatePost(context);
              },
              child: const Text('Update Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePost(BuildContext context) {
    // Execute mutation to update the post with the entered values
    final updatePostMutation = gql('''
      mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
        updateBlog(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
          success
          blogPost {
            id
            title
            subTitle
            body
            dateCreated
          }
        }
      }
    ''');

    final MutationOptions options = MutationOptions(
      document: updatePostMutation,
      variables: {
        'id': widget.blogId,
        'title': title,
        'subtitle': subTitle,
        'body': body,
      },
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
        // Post updated successfully
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Post updated successfully!'),
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
  }
}
