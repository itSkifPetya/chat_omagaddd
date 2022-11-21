import 'package:chat_omagaddd/screens/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Your email',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: 'Your password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                print("${emailController.text} logged in");
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserListScreen()));
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen, ),
            child: const Text("Войти"),
          )
        ],
      ),
    )
    );
  }
}
