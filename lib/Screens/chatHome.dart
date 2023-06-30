// ignore_for_file: file_names, prefer_const_constructors

import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:mind/Screens/chatCreate.dart";
import "package:mind/Screens/chatRoom.dart";
import "package:mind/Screens/home.dart";
import "package:shared_preferences/shared_preferences.dart";

import "authScreen.dart";

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final Stream<QuerySnapshot> _roomsStream =
      FirebaseFirestore.instance.collection('rooms').snapshots();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "View All Chatrooms",
            style: TextStyle(fontSize: 16),
          )),
          backgroundColor: Colors.grey.shade800,
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatCreate()));
              },
            ),
            IconButton(
              icon: Icon(Icons.post_add),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
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
            stream: _roomsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String docID = document.id;

                return Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                      docID: docID,
                                      title: data["topic"],
                                    )));
                      },
                      leading: Icon(
                        Icons.chat_bubble,
                        color: borderColor[Random().nextInt(8)],
                      ),
                      title: Text(data["topic"]),
                      subtitle: Text(data["description"]),
                      trailing: Text("-By ${poster[Random().nextInt(8)]}"),
                    ));
              }).toList());
            }));
  }
}
