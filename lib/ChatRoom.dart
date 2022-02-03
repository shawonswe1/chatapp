 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  // final Map<String,dynamic> userMap;
  var userList;
   String chatRoomID;
  ChatRoom({required this.chatRoomID,required this.userList,});

  @override
  State<ChatRoom> createState() => _ChatRoomState(chatRoomID,userList);
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  String crId;
  var userList;
  var userDetails;
  _ChatRoomState(this.crId, this.userList);

  Future getUserDetails() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireStore.collection("users").where("email",isEqualTo: currentUser?.email).get();
    print(qn.docs[0].data());
    userDetails = qn.docs;
    print(userDetails[0]['name']);
    print(userDetails.length);
    return userDetails;
  }

  void onSendMessage() async {
    if(_message.text.isNotEmpty){
      Map<String,dynamic> messages = {
        "sendby": userDetails[0]['name'],
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection("chatroom")
          .doc(crId)
          .collection("chats")
          .add(messages);
      _message.clear();
    }else
      {
        print("Enter Some Text");
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userList),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height/1.28,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("chatroom")
                      .doc(crId)
                      .collection("chats")
                      .orderBy("time",descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.data == null)
                    {
                      return Container(
                        child: Center(
                          child: Text("Loading...."),
                        ),
                      );
                    }else{
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context,int index){
                            // return Text(snapshot.data?.docs[index]['message']);
                            Map<String,dynamic>? map = snapshot.data?.docs[index].data() as Map<String, dynamic>?;
                            return messages(size,map!);
                          });
                    }
                  },
                ),
              ),
              Container(
                height: size.height/10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height/12,
                  width: size.width/1.1,
                  child: Row(
                    children: [
                      Container(
                        height: size.height/12,
                        width: size.width/1.5,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                              hintText: "Send Message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: onSendMessage,
                          icon: Icon(Icons.send))
                    ],
                  ),
                ),

              ),
            ],
          )
      ),
    );
  }

  Widget messages(Size size,Map<String,dynamic> map){
    return Container(
      width: size.width,
      alignment: map['sendby'] == userDetails[0]['name']
          ?Alignment.centerRight
          :Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue
          ),
          child: Text(map['message'],style: TextStyle(color: Colors.white),)),
    );
  }
}


