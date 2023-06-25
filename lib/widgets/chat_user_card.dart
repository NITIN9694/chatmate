

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_models.dart';
import '../screens/chat_screen.dart';


//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key,required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  // Message? _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(user: widget.user)));
      },
      child: Card(
       child: ListTile(leading: CircleAvatar(child: Text(widget.user.email.substring(0,1).toUpperCase(),
       style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.0),
       ),
       ),
       title: Text(widget.user.email.toString()),

       ),
      ),
    );
  }
}