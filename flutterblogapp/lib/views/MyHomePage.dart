import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterblogapp/views/NotificationPage.dart';
import 'package:flutterblogapp/views/deletepost.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutterblogapp/views/AddPostPage.dart';
import 'package:flutterblogapp/views/PostDetailsPage.dart';
import 'package:flutterblogapp/views/SavedPostPage.dart';
import 'package:flutterblogapp/views/SearchPage.dart';
import 'package:flutterblogapp/views/updatepost.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPostPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedPostPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchSavedPost(),
                ),
              ); // Handle search action
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ); // Handle notification action
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(
                'NewYorkTimes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Delete Post'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeletePostPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Update Post'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatePostPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Post'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPostPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    gapPadding: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    borderSide: BorderSide(color: Colors.white)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
          ),
          Expanded(
            child: Query(
                options: QueryOptions(
                  document: gql('''
      query fetchAllBlogs {
          allBlogPosts {
            id
            title
            subTitle
            body
            dateCreated
          }
        }
    '''),
                ),
                builder: (QueryResult result, {refetch, fetchMore}) {
                  if (result.hasException) {
                    return Text('Error: ${result.exception.toString()}');
                  }

                  if (result.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return FutureBuilder<bool>(
                    future: checkConnectivity(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.data!) {
                        // Handle no internet connectivity
                        return const Center(
                          child: Text(
                              'No internet connection. Please check your connection and try again.'),
                        );
                      } else {
                        final blogPost =
                            result.data?['allBlogPosts'] as List<dynamic>;
                        // If internet connection is available, proceed with rendering data

                        return Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: <Widget>[
                            ListView.builder(
                              itemCount: blogPost.length,
                              itemBuilder: (context, index) {
                                final post = blogPost[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PostDetailsPage(post['id']),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 250,
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post['title'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Expanded(
                                              child: Text(
                                                post['body'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Date Created: ${post['dateCreated']}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostDetailsPage(
                                                              post['id']),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                ),
                                                child: const Text(
                                                  'Read More',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    },
                    
                  );
                
                }
                ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Saved',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPostPage(),
                  ),
                );
              },
              tooltip: 'Add Post',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
