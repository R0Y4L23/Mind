// ignore_for_file: file_names, use_build_context_synchronously

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:mind/Screens/chatHome.dart";

class ChatCreate extends StatefulWidget {
  const ChatCreate({super.key});

  @override
  State<ChatCreate> createState() => _ChatCreateState();
}

class _ChatCreateState extends State<ChatCreate> {
  late String topic;
  late String description;

  CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');

  firebaseCreateRoom() async {
    Fluttertoast.showToast(msg: "Creating...");

    try {
      await rooms.add({
        'topic': topic,
        'description': description,
        'date': DateTime.now(),
        'chats': []
      });
      Fluttertoast.showToast(msg: "Creation Successful");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ChatHome()));
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text("Create a Chatroom"),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
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
              padding: const EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                decoration: const InputDecoration(
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
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text("Post"),
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
                    firebaseCreateRoom();
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("NOTE : The Creator Of Chatroom is Anonymous"),
            ),
          ],
        ),
      ),
    );
  }
}
