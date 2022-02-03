
import 'dart:convert';

import 'package:chatapp/ChatRoom.dart';
import 'package:chatapp/Methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var program;
var userProfile;
class _HomeScreenState extends State<HomeScreen> {
  Map<String,dynamic>? userMap;

  final FirebaseAuth _ath = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;



  bool isLoading = false;
  var userList;
  var userDetails;


  String chatRoomId(String user1,String user2){
    if(user1[0].toLowerCase().codeUnits[0]>user2.toLowerCase().codeUnits[0])
      {
        return "$user1$user2";
      }else{
      return "$user2$user1";
    }
  }
  void onSearch(String query) async{
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    await _firestore.collection("users").where("email",isEqualTo: query).
    get().then((value){
      setState(() {
        isLoading = false;
        userMap = value.docs[0].data();
      });
      print(userMap!['status']);
    });
  }

  Future getUserDetails() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireStore.collection("users").where("email",isEqualTo: currentUser?.email).get();
    print(qn.docs[0].data());
    userDetails = qn.docs;
    print(userDetails[0]['name']);
    print(userDetails.length);
    return userDetails;
  }

  Future getPosts() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireStore.collection("users").where("email",isNotEqualTo: currentUser?.email).get();
    print(qn.docs[0].data());
    userList = qn.docs;
    print(userList.length);
    print(userList.length);
    return userList;
  }

  Future getCategory() async {
    var response = await http.post(Uri.parse("https://shoppingzonebd.com.bd/api/get-category"),body: {
      "access_token": "0411f0028cfb768b3a3d96ac3aa373e5"
    });
    setState(() {
      // isLoading = false;
      var decode = json.decode(response.body);
      program = decode;
      print("Category "+program.length.toString());
      print(program[12]['cat_name']);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPosts();
    getCategory();
    getUserDetails();
  }

  Widget _buildCategory(BuildContext context) {
    return program?.length==0?Container():Container(
      height: MediaQuery.of(context).size.height/1.14,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getPosts(),
            builder: (context,AsyncSnapshot snapshot){
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
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        onTap: (){
                          String roomId = chatRoomId(userDetails[0]['name'],
                              snapshot.data[index]["name"]);
                          print(snapshot.data[index]["name"]);
                          print(userDetails[0]['name']);
                          debugPrint('${currentUser?.email}');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatRoom(chatRoomID: roomId,userList: snapshot.data[index]["name"],)));
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryProduct(CategoryId: program[index]["id"].toString(),CategoryName:program[index]["cat_name"] ,)));
                        },
                        child: Card(
                            child: SizedBox(
                              width: 90,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  trailing: const Icon(Icons.message_outlined),
                                  title: Text(snapshot.data[index]['name']),
                                  subtitle: Text(snapshot.data[index]['email']),
                                ),
                              ),
                            )
                        ),
                      );
                    });
              }

        })
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.orange,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onSubmitted: (value){
                    print(value);
                    onSearch(value);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(SearchQuery: value,)));
                  },
                ),
              ),
              userMap != null?Container():_buildCategory(context),
              // Container(
              //   child: Text("user list"),
              // ),
              // Container(
              //     child: FutureBuilder(
              //         future: getPosts(),
              //         builder: (BuildContext context,AsyncSnapshot snapshot){
              //           if(snapshot.data == null)
              //           {
              //             return Container(
              //               child: Center(
              //                 child: Text("Loading...."),
              //               ),
              //             );
              //           }else{
              //             return ListView.builder(
              //                 itemCount: snapshot.data.length,
              //                 itemBuilder: (BuildContext context,int index){
              //                   return ListTile(
              //                     title: Text(snapshot.data[index]['email']),
              //                   );
              //                 });
              //           }
              //
              //         })
              // ),
            ],
          ),
        ],
      )
    );
  }
}





