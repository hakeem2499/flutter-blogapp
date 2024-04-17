// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SearchSavedPost extends StatelessWidget {
  const SearchSavedPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
      ),
      body: 
      SearchBar(
             hintText: "search posts",
             
          ),
          );
  }
}
