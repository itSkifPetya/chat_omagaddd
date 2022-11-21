import 'package:chat_omagaddd/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatWindow extends StatefulWidget {
  final String recipient;
  const ChatWindow({Key? key, required this.recipient}) : super(key: key);
  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _messageContoller = TextEditingController();
  final _ref = FirebaseDatabase.instance.ref('messages');
  final messageName = 'message';
  late String recipient;
  final sender = FirebaseAuth.instance.currentUser!.uid.toString();

  final ImagePicker _picker = ImagePicker();
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    recipient = widget.recipient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text(recipient),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                child: FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: _ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    if (snapshot.child('sender').value.toString() == sender &&
                    snapshot.child('recipient').value.toString() == recipient) {
                      if (snapshot.child('image').value.toString() != '' &&
                      snapshot.child(messageName).value.toString() == '') {
                        return Image.network(snapshot.child('image').value.toString());
                      } else {
                        return ListTile(
                          tileColor: Colors.lightBlue,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _ref.child(snapshot.key!).remove();
                            },
                          ),
                          title: Text(
                              snapshot.child(messageName).value.toString()),
                          leading: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                              maxHeight: 64,
                              maxWidth: 64
                            ),
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.child('sender').value.toString() == recipient &&
                    snapshot.child('recipient').value.toString() == sender) {
                      if (snapshot.child('image').value.toString() != '' &&
                          snapshot.child(messageName).value.toString() == '') {
                        return Image.network(snapshot.child('image').value.toString());
                      } else {
                        return ListTile(
                            tileColor: Colors.yellow,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _ref.child(snapshot.key!).remove();
                              },
                            ),
                            title: Text(
                                snapshot.child(messageName).value.toString()));
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: _messageContoller,
                        ),
                      ),
                      const Spacer(flex: 1,),
                      Flexible(
                        flex: 1,
                        child:
                        ElevatedButton(onPressed: () {
                          _ref.push().set({
                            'sender': sender,
                            'recipient': recipient,
                            'message': _messageContoller.text
                          }).asStream();
                          _messageContoller.clear();
                        }, child: Text('Send')),
                      ),
                      const Spacer(flex: 1,),
                      Flexible(
                          flex: 1,
                          child: ElevatedButton(onPressed: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            storage.uploadFile(
                                image!.path, image.name, sender, recipient).then((
                                value) => print('Done'));
                          }, child: const Text('#'))
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
