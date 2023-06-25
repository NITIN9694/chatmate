import 'package:flutter/material.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final double boxSize;
  final Function(String) onOtpEntered;
  final String initialOtp;

  CustomOtpField({
    this.length = 4,
    this.boxSize = 50,
    required this.onOtpEntered,
    this.initialOtp = '',
  });

  @override
  _CustomOtpFieldState createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      focusNodes.add(FocusNode());
      controllers.add(TextEditingController());
    }
    if (widget.initialOtp.isNotEmpty) {
      for (int i = 0; i < widget.initialOtp.length && i < widget.length; i++) {
        controllers[i].text = widget.initialOtp[i];
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      value = value.substring(value.length - 1);
      controllers[index].text = value;
    }

    if (index < widget.length - 1 && value.isNotEmpty) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }

    String otp = "";
    for (var controller in controllers) {
      otp += controller.text;
    }
    widget.onOtpEntered(otp);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> otpFields = [];

    for (int i = 0; i < widget.length; i++) {
      otpFields.add(
        Container(
          width: widget.boxSize,
          child: TextFormField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (value) => _onOtpChanged(value, i),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: otpFields,
    );
  }
}