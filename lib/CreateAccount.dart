import 'package:chatapp/HomeScreen.dart';
import 'package:chatapp/LoginScreen.dart';
import 'package:chatapp/Methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Container(
                  alignment: Alignment.center,
                  child: const Text("Welcome",style: TextStyle(fontSize: 20),)
              ),
            ),
            const SizedBox(height: 30,),
            Column(
              children: [
                field(size, "Name",Icons.account_box,_name),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: field(size, "email",Icons.email,_email),
                ),
                field(size, "password",Icons.lock,_password),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: customButton(size,"Create Account",20),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                    child: const Text("Log In")),
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
        if(_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty)
          {
            setState(() {
              isLoading = true;
            });
            createAccount(_name.text, _email.text, _password.text)
                .then((user) {
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
          print("Please enter Fields");
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
