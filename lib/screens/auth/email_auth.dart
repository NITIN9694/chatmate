import 'package:chatmate/api/api.dart';
import 'package:chatmate/screens/auth/phone_auth.dart';
import 'package:chatmate/screens/home_screen.dart';
import 'package:chatmate/utills/utills.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmaiAuth extends StatefulWidget {
  const EmaiAuth({Key? key}) : super(key: key);

  @override
  State<EmaiAuth> createState() => _EmaiAuthState();
}

class _EmaiAuthState extends State<EmaiAuth> {




// Example usage of the signUp method
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController singInEmailController = TextEditingController();
  TextEditingController singInPasswordController = TextEditingController();
  bool isSingup = false;
  bool isSigininLoading = false;
  bool isSiginUpLoading = false;



  void signUpWithEmailAndPassword() async {
    final UserCredential userCredential;

    print("email-> ${emailController.text}");
    print("password-> ${passwordController.text}");
    // if(!await APIs.userExists()){
    //
    // }else {
      setState(() {
        isSiginUpLoading = true;
      });
      if (passwordController.text == confirmPasswordController.text) {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          print("tessss");


          setState(() {
            isSiginUpLoading = false;
          });
          APIs.createUser().then((value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          });

        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              isSiginUpLoading = false;
            });
            Utills.showSnackbar(context, "weak-password");
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              isSiginUpLoading = false;
            });
            Utills.showSnackbar(
                context, "The account already exists for that email");
            print('.');
          }
        } catch (e) {
          print(e);
        }
      } else {
        setState(() {
          isSiginUpLoading = false;
        });
        Utills.showSnackbar(context, "Password not matched");
      }
    }

  void signInWithEmailAndPassword() async {
UserCredential userCredential;
      setState(() {
        isSigininLoading = true;
      });
      print("email-> ${singInEmailController.text}");
      print("password-> ${singInPasswordController.text}");

      try {
        (() {
          isSigininLoading = false;
        });
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: singInEmailController.text,
          password: singInPasswordController.text,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            isSigininLoading = false;
          });
          Utills.showSnackbar(context, e.toString());
        } else if (e.code == 'user-not-found') {
          setState(() {
            isSigininLoading = false;
          });
          Utills.showSnackbar(context, "wrong-password");
        } else {
          setState(() {
            isSigininLoading = false;
          });
          Utills.showSnackbar(context, e.toString());
        }
      } catch (e) {
        setState(() {
          isSigininLoading = false;
        });
        Utills.showSnackbar(context, e.toString());
        print('.');

    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSingup ?
            SingupWidget()
                :
                SinginWidget(),

             Align(
               alignment: Alignment.centerRight,
               child: InkWell(onTap: (){
                 setState(() {
                   isSingup =! isSingup;
                 });

               },
               child: isSingup?Text("Singin",style: TextStyle(color: Colors.blue,fontSize: 18.0,fontWeight: FontWeight.bold),):Text("Singup",style: TextStyle(color: Colors.blue,fontSize: 18.0,fontWeight: FontWeight.bold),),
               ),
             ),

            Align(
              alignment: Alignment.center,
              child: InkWell(onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PhoneAuth(),
                    ));

              },
                child: isSingup?Text("Login With Phone",style: TextStyle(color: Colors.blue,fontSize: 18.0,fontWeight: FontWeight.bold),):Text("Singup With Phone",style: TextStyle(color: Colors.blue,fontSize: 18.0,fontWeight: FontWeight.bold),),
              ),
            )

          ],
        ),
      ),
    );
  }
  Widget SingupWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Email',
              style:TextStyle(color: Colors.black,fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style:TextStyle(color: Colors.black,fontSize: 20.0),
                controller:emailController,

                decoration: InputDecoration(
                  hintText: "Enter Email",
                  contentPadding: EdgeInsets.only(top: 1, left: 13),
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.0),
                  border: InputBorder.none,
                  labelStyle:TextStyle(color: Colors.black,fontSize: 16.0),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:  Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Password',
              style:TextStyle(color: Colors.black,fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style:TextStyle(color: Colors.black,fontSize: 20.0),
                controller:passwordController,

                decoration: InputDecoration(
                  hintText: "Enter Password",
                  contentPadding: EdgeInsets.only(top: 1, left: 13),
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.0),
                  border: InputBorder.none,
                  labelStyle:TextStyle(color: Colors.black,fontSize: 16.0),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:  Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Text(
              'Confirm Password',
              style:TextStyle(color: Colors.black,fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style:TextStyle(color: Colors.black,fontSize: 20.0),
                controller:confirmPasswordController,

                decoration: InputDecoration(
                  hintText: "Enter Confirm Password",
                  contentPadding: EdgeInsets.only(top: 1, left: 13),
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.0),
                  border: InputBorder.none,
                  labelStyle:TextStyle(color: Colors.black,fontSize: 16.0),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:  Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){

                signUpWithEmailAndPassword();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child:isSiginUpLoading ? CircularProgressIndicator(color: Colors.white,):Text("Singup",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
                   ],
        )
      ],
    );
  }
  Widget SinginWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Email',
              style:TextStyle(color: Colors.black,fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style:TextStyle(color: Colors.black,fontSize: 20.0),
                controller:singInEmailController,

                decoration: InputDecoration(
                  hintText: "Enter Email",
                  contentPadding: EdgeInsets.only(top: 1, left: 13),
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.0),
                  border: InputBorder.none,
                  labelStyle:TextStyle(color: Colors.black,fontSize: 16.0),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:  Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Password',
              style:TextStyle(color: Colors.black,fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style:TextStyle(color: Colors.black,fontSize: 20.0),
                controller:singInPasswordController,

                decoration: InputDecoration(
                  hintText: "Enter Password",
                  contentPadding: EdgeInsets.only(top: 1, left: 13),
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 16.0),
                  border: InputBorder.none,
                  labelStyle:TextStyle(color: Colors.black,fontSize: 16.0),
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:  Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                signInWithEmailAndPassword();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: isSigininLoading ? CircularProgressIndicator(color: Colors.white,):Text("Singin",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )
      ],
    );
  }
}
