import 'package:chat_omagaddd/screens/user_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
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
            controller: loginController,
            decoration: const InputDecoration(
                labelText: 'Your login',
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
              final credential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );
              ref
                  .child(credential.user!.uid)
                  .child('login')
                  .set(loginController.text);
              ref
                  .child(credential.user!.uid)
                  .child('uid')
                  .set(credential.user!.uid);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserListScreen()));
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
              }
            } catch (e) {
              print(e);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
          child: const Text('Регистрация'),
        )
      ],
    )));

  }
}
