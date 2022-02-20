// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'dart:math';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./post.dart";
import "./authScreen.dart";

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  String uid = "";

  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      setState(() {
        uid = prefs.getString('userId').toString();
        print("userId is " + uid);
      });
    });
  }

  firebaseLikeUpdater(idOfPost) async {
    await posts.doc(idOfPost).update({
      'likedBy': FieldValue.arrayUnion([uid])
    });
  }

  firebaseLikeDowndater(idOfPost) async {
    await posts.doc(idOfPost).update({
      'likedBy': FieldValue.arrayRemove([uid])
    });
  }

  List<String> poster = [
    'Someone',
    'Anonymous',
    'Thinker',
    'Faceless',
    'Unknown',
    'Mysterious',
    'Stranger',
    'Unnamed',
    'Nameless'
  ];

  List<Color> borderColor = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("View All Minds")),
          backgroundColor: Colors.grey.shade800,
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDataFromMind()));
              },
            ),
            IconButton(
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Auth()));
                  });
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: StreamBuilder(
            stream: _postsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  Icon likeicon;

                  if (data['likedBy'].contains(uid)) {
                    likeicon = Icon(Icons.favorite);
                  } else {
                    likeicon = Icon(Icons.favorite_border);
                  }

                  return Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: borderColor[Random().nextInt(8)]),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data['image'] != null && data['image'] != ""
                            ? Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Image.network(
                                  data['image'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              data['topic'],
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Text(
                            data['description'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Posted by: " +
                                        poster[Random().nextInt(poster.length)],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (data['likedBy'].contains(uid)) {
                                              firebaseLikeDowndater(
                                                  document.id);
                                            } else {
                                              firebaseLikeUpdater(document.id);
                                            }
                                          },
                                          icon: Icon(
                                            likeicon.icon,
                                          )),
                                      Text(
                                        data['likedBy'].length.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  )
                                ])),
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
