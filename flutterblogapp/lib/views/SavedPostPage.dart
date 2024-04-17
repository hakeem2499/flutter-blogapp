// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterblogapp/views/PostDetailsPage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SavedPostPage extends StatelessWidget {
  const SavedPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Post'),
      ),
    );
  }
}
