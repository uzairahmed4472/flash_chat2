import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat2/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firstore = FirebaseFirestore.instance;
  User? user;
  final textEditingController = TextEditingController();

  checkUser() {
    user = _auth.currentUser;
    if (user != null) {
      print(user);
    }
  }

  Future fetchMessages() async {
    final list = [];
    final querySnapshot = await _firstore.collection("messages").get();

    final listQS = querySnapshot.docs;

    for (var document in listQS) {
      document.data();
      list.add(document.data());
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                print(123);
                final data = await fetchMessages();
                print(data);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: fetchMessages(),
                  builder: (context, snap) {
                    List messages = snap.data;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.blue,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Text(snap.data[index]["message"]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      controller: textEditingController,
                      onChanged: (value) {
                        print("$value");
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _firstore.collection("messages").add({
                        "sender": "${user!.email}",
                        "message": "${textEditingController.text}",
                      });
                      textEditingController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
