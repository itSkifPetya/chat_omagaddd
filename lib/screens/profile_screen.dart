import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String login;
  const ProfileScreen({Key? key, required this.login}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String login;

  @override
  void initState() {
    super.initState();
    login = widget.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              minWidth: 100,
              maxWidth: 120,
              maxHeight: 120,
            ),
            child: Container(
              color: Colors.blueGrey,
            ),
          ),

          Row(
            children: [
              const Text('Login:'),
              Text(login),
            ],
          )
        ],
      ),
    );
  }
}
