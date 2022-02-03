import 'package:chatapp/HomeScreen.dart';
import 'package:chatapp/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticatScreen extends StatefulWidget {
  const AuthenticatScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticatScreen> createState() => _AuthenticatScreenState();
}

class _AuthenticatScreenState extends State<AuthenticatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    if(_auth.currentUser != null)
      {
        return HomeScreen();
      }else
        {
          return LoginScreen();
        }
  }
}

