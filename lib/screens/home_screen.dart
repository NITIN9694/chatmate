import 'dart:developer';

import 'package:chatmate/api/api.dart';
import 'package:chatmate/screens/auth/email_auth.dart';
import 'package:chatmate/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';

import '../models/chat_models.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
     await APIs.getFirebaseMessagingToken();
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton(
       onPressed: (){
         
       },
        child: Icon(Icons.chat,color:Colors.white,),
      ) ,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.person,color: Colors.black,)),
          IconButton(onPressed:  (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  EmaiAuth(),
              ),
            );
          }
      , icon: const Icon(Icons.login,color: Colors.black,))


        ],
        backgroundColor: Colors.white,
        title: const Text("ChatMate"),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: APIs.getAllUsers(),

        //get only those user, who's ids are provided
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
          //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
            // return const Center(
            //     child: CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _list = data
                  ?.map((e) => ChatUser.fromJson(e.data()))
                  .toList() ??
                  [];

              if (_list.isNotEmpty) {
                              return ListView.builder(
                    itemCount:_list.length,
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {


                      return APIs.firestore.collection('users').doc(APIs.user.uid).get().toString() == _list[index].id
                      ? SizedBox():ChatUserCard(
                          user : _list[index]);
                    });
              } else {
                return const Center(
                  child: Text('No Connections Found!',
                      style: TextStyle(fontSize: 20)),
                );
              }
          }
        },
      )


    );
  }
}
