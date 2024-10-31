import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat2/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? user;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firstore = FirebaseFirestore.instance;
  final textEditingController = TextEditingController();
  String? messageText = "";

  checkUser() {
    user = _auth.currentUser;
    if (user != null) {
      print(user);
    }
  }

  // Future fetchMessages() async {
  //   final list = [];
  //   final querySnapshot = await _firstore.collection("messages").get(); //querysnapshot
  //   final listQS = querySnapshot.docs; //convet to listQS
  //   for (var document in listQS) {
  //     document.data();
  //     list.add(document.data());
  //   }
  //   return list;
  // }

  // getStreamMessage() async {
  //   final streamQS = await _firstore.collection("messages").snapshots();
  //   // print(streamQS);
  //   await for (var snapshot in streamQS) {
  //     print(snapshot);
  //     print(snapshot.docs.length);
  //     for (var document in snapshot.docs) {
  //       print(document.data());
  //     }
  //   }
  // }

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
                checkUser();
                // getStreamMessage();
                // final data = await fetchMessages();
                // print(data);
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
            MessageStream(),
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
                        messageText = value;
                        print("$value");
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (textEditingController.text.trim() != "") {
                        await _firstore.collection("messages").add({
                          "sender": "${user!.email}",
                          "message": "${messageText}",
                          "timestamp": Timestamp.now()
                        });
                        textEditingController.clear();
                      }
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

class MessageStream extends StatelessWidget {
  MessageStream({
    super.key,
  });
  final currentUser = user?.email ?? "";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        final messages = snapshot.data!.docs;

        if (!snapshot.hasData) {
          Text("Data fetching error");
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index].data();
                final isMe = currentUser == message['sender'];
                return Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${message['sender']}   ",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.pink,
                        borderRadius: isMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )
                            : BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "${message['message']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
