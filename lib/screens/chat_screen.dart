
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatmate/utills/utills.dart';
import 'package:chatmate/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/chat_models.dart';
import '../models/message_model.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar:AppBar(
      flexibleSpace: _appBar(),
     backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
    ) ,
      body:Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();

                //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;

                    _list = data
                        ?.map((e) => Message.fromJson(e.data()))
                        .toList() ??
                        [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          });
                    } else {
                      return const Center(
                        child: Text('Say Hii! 👋',
                            style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
          ),


          _chatInput(),

        ],
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(top:50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: (){
                Navigator.pop(context);
              }
              ,child: Icon(Icons.arrow_back, color: Colors.black54)),


          Text(widget.user.email,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
          SizedBox()

        ],
      ),
    );
  }


  // // bottom chat input field
  Widget _chatInput() {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal:8.0),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Expanded(child: Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           child: Row(
             children: [

               Expanded(
                   child: TextField(
                     controller: _textController,
                     keyboardType: TextInputType.multiline,
                     maxLines: null,
                     onTap: () {

                     },
                     decoration: const InputDecoration(
                         hintText: 'Type Something...',
                         hintStyle: TextStyle(color: Colors.black),
                         border: InputBorder.none),
                   )),
             ],

           ),
         )),
      MaterialButton(
      onPressed: () {
        if (_textController.text.isNotEmpty) {

            //simply send message
            APIs.sendMessage(
                widget.user, _textController.text);

          _textController.text = '';
        }
      },
      minWidth: 0,
      padding:
      const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
      shape: const CircleBorder(),
      color: Colors.black,
      child: const Icon(Icons.send, color: Colors.white, size: 28)),
       ],
     ),
   );
  }
}