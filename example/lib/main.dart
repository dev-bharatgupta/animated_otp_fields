import 'package:flutter/material.dart';
import 'package:animated_otp_fields/animated_otp_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OTP_Submission(),
    );
  }
}

class OTP_Submission extends StatefulWidget {
  OTP_Submission({Key key}) : super(key: key);

  @override
  _OTP_SubmissionState createState() => _OTP_SubmissionState();
}

class _OTP_SubmissionState extends State<OTP_Submission> {
  TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator(),
          animated_otp_fields(
            textEditingController,
            fieldHeight: 50,
            fieldWidth: 40,
            OTP_digitsCount: 6,
            animation: TextAnimation.Rotation,
            border: Border.all(width: 3, color: Colors.purple),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            contentPadding: EdgeInsets.only(bottom: 3),
            forwardCurve: Curves.linearToEaseOut,
            textStyle: TextStyle(
                color: Colors.pink, fontSize: 30, fontWeight: FontWeight.bold),
            onFieldSubmitted: (text) {
              print(textEditingController.text);
            },
          ),
          SizedBox(
            height: 20,
          ),
          // CircularProgressIndicator(),
          MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content:
                            Text('your otp is ${textEditingController.text}'),
                      ));
            },
            color: Colors.purple,
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
