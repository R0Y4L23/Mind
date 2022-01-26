// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "./home.dart";

class PostDataFromMind extends StatefulWidget {
  PostDataFromMind({Key? key}) : super(key: key);

  @override
  State<PostDataFromMind> createState() => _PostDataFromMindState();
}

class _PostDataFromMindState extends State<PostDataFromMind> {
  String topic = "";
  String description = "";

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  firebasePost() async {
    Fluttertoast.showToast(msg: "Posting...");
    try {
      await posts.add({
        'topic': topic,
        'description': description,
        'date': DateTime.now(),
        'likedBy': [],
      });
      Fluttertoast.showToast(msg: "Post Successful");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text("What's On Your Mind?"),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Give A Name",
                ),
                onChanged: (value) {
                  setState(() {
                    topic = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Describe...",
                ),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text("Post"),
                onPressed: () {
                  if (topic.isEmpty || description.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Please fill all the fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    firebasePost();
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "NOTE : The Post is Anonymous. Only Date and Time is recorded."),
            ),
          ],
        ),
      ),
    );
  }
}
