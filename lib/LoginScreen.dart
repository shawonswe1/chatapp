import 'package:chatapp/CreateAccount.dart';
import 'package:chatapp/Methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatApp"),
      ),
      body: isLoading? Center(
        child: Container(
          height: size.height/20,
          width: size.height/20,
          child: const CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                alignment: Alignment.center,
                  child: const Text("Welcome",style: TextStyle(fontSize: 20),)
              ),
            ),
            const SizedBox(height: 30,),
            Column(
              children: [
                field(size, "email",Icons.account_box,_email),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: field(size, "password",Icons.lock,_password),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: customButton(size,"Login",20),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateAccount()));
                  },
                    child: const Text("create account")
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget customButton(Size size,String buttonText,double textSize)
  {
    return GestureDetector(
      onTap: (){
        if(_email.text.isNotEmpty &&
            _password.text.isNotEmpty){
          setState(() {
            isLoading = true;
          });
          logIn(_email.text, _password.text).then((user) {
            if(user != null){
              setState(() {
                isLoading = false;
              });
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
              print("Login Successfull");
            }else{
              print("Login Failed");
            }
          });
        }else{
          print("Please fill form correctly");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue
        ),
        alignment: Alignment.center,
        child: Text(buttonText,
          style: TextStyle(
              color: Colors.white,
              fontSize:textSize,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
  Widget field(Size size,String hintText, IconData icon, TextEditingController controller) {
    return Container(
      height: size.height/15,
      width: size.width/1.1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
      ),
    );
  }
}


