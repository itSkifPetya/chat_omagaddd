import 'package:chat_omagaddd/screens/chat_window.dart';
import 'package:chat_omagaddd/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _ref = FirebaseDatabase.instance.ref('users');
  var _login = 'default user';


  @override
  void initState() {
    super.initState();

    RealtimeDatabase.read(
            userId: '${FirebaseAuth.instance.currentUser!.uid}/login')
        .then((value) {
      setState(() {
        if (value is String) {
          _login = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_login),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Flexible(flex: 12,child: FirebaseAnimatedList(
            shrinkWrap: true,
            query: _ref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              if (snapshot.child('login').value.toString() == _login) {
                return ListTile(
                  title: const Text('Избранные'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatWindow(
                                recipient:
                                snapshot.child('uid').value.toString())));
                    print(snapshot.child('uid').value.toString());
                  },
                );
              }
              else {
                return ListTile(
                  title: Text(snapshot.child('login').value.toString()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatWindow(
                                recipient:
                                snapshot.child('uid').value.toString())));
                    print(snapshot.child('uid').value.toString());
                  },
                );
              }
            },
          ),
          ),
          Flexible(flex: 2,child: ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(login: '_login',)));
          }, child: const Text('Мой профиль')),)
        ],
      )
    );
  }
}

class RealtimeDatabase {
  static Future<Object?> read({required String userId}) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$userId').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      return '';
    }
  }
}
