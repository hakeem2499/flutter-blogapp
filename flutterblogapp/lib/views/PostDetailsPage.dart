
import 'dart:ui';
import 'package:flutterblogapp/views/deletepost.dart';
import 'package:flutterblogapp/views/updatepost.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostDetailsPage extends StatelessWidget {
  final String blogId;

  const PostDetailsPage(this.blogId, {super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
        PopupMenuButton<String>(
          onSelected: (String value) {
            if (value == 'delete') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeletePostPage(),
                ),
              );
            } else if (value == 'update') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePostPage(),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete Post'),
            ),
            const PopupMenuItem<String>(
              value: 'update',
              child: Text('Update Post'),
            ),
          ],
        ),
      ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql('''
            query getBlog(\$blogId: String!) {
            blogPost(blogId: \$blogId) {
              id
              title
              subTitle
              body
              dateCreated
            }
          }
          '''),
          variables: {'blogId': blogId},
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text('Error: ${result.exception.toString()}');
          }

          if (result.isLoading) {
            return const CircularProgressIndicator();
          }

          final blogPost = result.data?['blogPost'];
          final formattedDate = DateFormat.yMMMMd().add_jm().format(DateTime.parse(blogPost['dateCreated']));
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${blogPost['title']}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Subtitle: ${blogPost['subTitle']}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Text(
                  blogPost['body'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date Created: $formattedDate',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
