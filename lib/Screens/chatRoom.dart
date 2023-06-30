// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, invalid_return_type_for_catch_error, avoid_print, avoid_init_to_null, unused_field, unnecessary_null_comparison, unnecessary_new

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  final String title;
  final String docID;
  const ChatRoom({super.key, required this.title, required this.docID});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String message = "";
  String userID = "";
  CollectionReference chats = FirebaseFirestore.instance.collection('rooms');
  TextEditingController messageController = new TextEditingController();

  late Stream documentStream;

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

  Future<void> sendMessage(String m) async {
    var d = null;
    await chats
        .doc(widget.docID)
        .get()
        .then((value) => {d = value.data()})
        .catchError((e) => {print("Error $e")});

    var c = d["chats"];

    c.add({"message": m, "datetime": DateTime.now(), "uid": userID});

    chats.doc(widget.docID).update({"chats": c});
  }

  Future<void> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString("userId")!;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    // Format the date
    String day = dateTime.day.toString();
    String month = _getMonthName(dateTime.month);
    String year = dateTime.year.toString();
    String dateSuffix = _getDateSuffix(dateTime.day);

    // Format the time
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    // Combine the formatted date and time
    String formattedDateTime = '$day$dateSuffix $month $year, $hour:$minute';

    return formattedDateTime;
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String _getDateSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  void initState() {
    getUID();
    documentStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.docID)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(widget.title),
        ),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 8,
              child: SizedBox(
                width: deviceWidth,
                child: SingleChildScrollView(
                    reverse: true,
                    child: documentStream == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : StreamBuilder(
                            stream: documentStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return Column(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data["chats"].length;
                                      i++)
                                    Align(
                                        alignment: snapshot.data["chats"][i]
                                                    ["uid"] ==
                                                userID
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          width: deviceWidth * 0.62,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: borderColor[
                                                      Random().nextInt(8)]),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data["chats"][i]
                                                    ["message"],
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "- ${poster[Random().nextInt(8)]}, ${formatTimestamp(snapshot.data["chats"][i]["datetime"])}",
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                        )),
                                ],
                              );
                            })),
              )),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Type Your Message",
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                          onPressed: () {
                            if (messageController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Message Cannot Be Empty",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              sendMessage(messageController.text);
                              messageController.clear();
                            }
                          },
                          icon: Icon(Icons.send)))
                ],
              ))
        ],
      ),
    );
  }
}
