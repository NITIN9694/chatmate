
import 'package:chatmate/screens/auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../utills/coustom_otp_filed.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController mobileController = TextEditingController();
  bool isOtp = false;
  OtpFieldController otpFieldController = OtpFieldController();
  List<String> otp = ["1","2","4","5","2",];
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: isOtp?OtpWidget() :MobileWidget()
    );
  }

  Widget MobileWidget(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('Enter Mobile Number', style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Colors.black26),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  Expanded(
                    child: TextFormField(
                      controller: mobileController,

                      style:TextStyle(fontSize: 14.0, color: Colors.black),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter Moobile Number',
                        hintStyle:TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: (){
               setState(() {
                 isOtp = true;
               });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.all(14),
                child: Center(
                  child:Text("Submit",style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      )]),
    );
  }

  Widget OtpWidget(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomOtpField(
                    length: 6, // Set the desired OTP length
                    boxSize: 50, // Set the size of each box
                    onOtpEntered: (otp) {

                    },
                    initialOtp: '789422',
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EmaiAuth(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: EdgeInsets.all(14),
                      margin: EdgeInsets.all(20),
                      child: Center(
                        child:Text("Enter Otp",style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ],
              ),
            )]),
    );
  }
}
