// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace, deprecated_member_use, prefer_typing_uninitialized_variables, unused_catch_clause, nullable_type_in_catch_clause, use_build_context_synchronously
import 'dart:io';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import "./home.dart";

class PostDataFromMind extends StatefulWidget {
  PostDataFromMind({Key? key}) : super(key: key);

  @override
  State<PostDataFromMind> createState() => _PostDataFromMindState();
}

class _PostDataFromMindState extends State<PostDataFromMind> {
  String topic = "";
  String description = "";
  String downloadUrl = "";
  var image;

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  final ImagePicker _picker = ImagePicker();

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('images/${file.path}')
          .putFile(file);

      final ref = await firebase_storage.FirebaseStorage.instance
          .ref('images/${file.path}')
          .getDownloadURL();

      setState(() {
        downloadUrl = ref.toString();
        print(downloadUrl);
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "Image Upload Failed");
    }
  }

  firebasePost() async {
    Fluttertoast.showToast(msg: "Posting...");

    if (image != null) {
      await uploadFile(image);
    } else {
      Fluttertoast.showToast(msg: "You are Uploading post without any Image");
    }

    try {
      await posts.add({
        'topic': topic,
        'description': description,
        'date': DateTime.now(),
        'likedBy': [],
        'image': downloadUrl,
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
    double deviceHeight = MediaQuery.of(context).size.height;

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                height: deviceHeight * 0.2,
                margin: EdgeInsets.only(
                    top: deviceHeight * 0.05, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: image != null
                      ? Image.file(File(image), fit: BoxFit.cover)
                      : IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () {
                            _picker
                                .pickImage(source: ImageSource.gallery)
                                .then((file) {
                              setState(() {
                                image = file!.path;
                              });
                            });
                          },
                        ),
                ),
              ),
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
                    "NOTE : The Post is Anonymous. Only Date and Time is recorded. Image is optional."),
              ),
            ],
          ),
        ));
  }
}
