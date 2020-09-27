import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = new TextEditingController();
    return MaterialApp(
        home: Center(
      child: Scaffold(
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
                  color: Colors.pink,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              onFieldSubmitted: (text) {
                print(textEditingController.text);
              },
            ),
            SizedBox(
              height: 20,
            ),
            // CircularProgressIndicator(),
            MaterialButton(
              onPressed: () {},
              color: Colors.purple,
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

// class test extends StatelessWidget {
//   const test({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("asdf"),
//     );
//   }
// }

enum TextAnimation { Scaling, Fading, None, Rotation, Sizing }
//enum Border{  }

class animated_otp_fields extends StatefulWidget {
  int OTP_digitsCount;
  final TextEditingController textEditingController;
  final bool autoFocus;
  final TextStyle textStyle;
  final Function(String) onFieldSubmitted;
  final double spaceBetweenFields;
  final double fieldWidth;
  final double fieldHeight;
  final Color fieldBackgroungColor;
  final EdgeInsetsGeometry contentPadding;
  final TextAnimation animation;
  final Duration duration;
  final Curve forwardCurve;
  final Curve reverseCurve;
  final bool obscureText;
  final String obscureCharacter;
  final Border border;
  final BorderRadiusGeometry borderRadius;
  final TextInputType keyboardType;

  animated_otp_fields(this.textEditingController,
      {this.OTP_digitsCount = 6,
      this.keyboardType = TextInputType.number,
      this.onFieldSubmitted,
      this.obscureCharacter = '*',
      this.borderRadius,
      this.border = const Border(bottom: BorderSide(width: 2)),
      this.autoFocus = true,
      this.fieldWidth = 30.0,
      this.fieldHeight = 30.0,
      this.textStyle = const TextStyle(fontSize: 20),
      this.fieldBackgroungColor = Colors.transparent,
      this.contentPadding = const EdgeInsets.all(0.0),
      this.animation = TextAnimation.Fading,
      this.duration = const Duration(seconds: 1),
      this.forwardCurve = Curves.linear,
      this.reverseCurve = Curves.linear,
      this.obscureText = false,
      this.spaceBetweenFields = 20.0});

  @override
  _animated_otp_fieldState createState() => _animated_otp_fieldState();
}

class _animated_otp_fieldState extends State<animated_otp_fields>
    with TickerProviderStateMixin {
  ///my texteditingcontrolles  used in hidden textfiedls;
  TextEditingController _OTPcontroller;
  FocusNode _OTPfocusnode;
  List<AnimationController> _animationController;
  List<Animation> _animation;

  List<Widget> _textfield;

  ///String use to display the otp
  List<String> _OTPentry;
  int idx;
  int oldOTPLength = 0;

  @override
  void didUpdateWidget(animated_otp_fields oldWidget) {
    if (oldWidget.OTP_digitsCount != widget.OTP_digitsCount ||
        oldWidget.duration != widget.duration ||
        oldWidget.forwardCurve != widget.forwardCurve ||
        oldWidget.reverseCurve != widget.reverseCurve ||
        oldWidget.textEditingController != widget.textEditingController) {
      int oldOTPLength = 0;

      print("didupdate");
      // TODO: implement didUpdateWidget
      ///maximum value of otp digits can be 8
      if (widget.OTP_digitsCount > 8) widget.OTP_digitsCount = 8;

      ///minimum value of otp digits can be 1
      if (widget.OTP_digitsCount <= 0) widget.OTP_digitsCount = 1;
      idx = 0;
      _OTPcontroller = new TextEditingController();
      _OTPfocusnode = new FocusNode();

      _animationController =
          new List<AnimationController>(widget.OTP_digitsCount);
      _animation = new List<Animation>(widget.OTP_digitsCount);

      for (int i = 0; i < widget.OTP_digitsCount; i++) {
        _animationController[i] = new AnimationController(
            vsync: this,
            duration: widget.animation != TextAnimation.None
                ? widget.duration
                : const Duration(microseconds: 1));

        _animation[i] = new Tween<double>(end: 1, begin: 0).animate(
            CurvedAnimation(
                parent: _animationController[i],
                curve: widget.forwardCurve,
                reverseCurve: widget.reverseCurve))
          ..addListener(() {
            if (widget.animation == TextAnimation.Rotation) setState(() {});
          });
      }

      /// creating list to show text (otp)
      _OTPentry = new List(widget.OTP_digitsCount);

      /// assigning intial value to _otpentry this to forward and reverse the animation easily
      for (int i = 0; i < widget.OTP_digitsCount; i++) _OTPentry[i] = "~";

      ///Number of total widgetts in row will be this.
      _textfield = new List(widget.OTP_digitsCount * 2 - 1);

      _OTPcontroller.addListener(() {
        final newOTPLength = _OTPcontroller.text.length;
        widget.textEditingController.text = _OTPcontroller.text;

        if (newOTPLength > 0 && newOTPLength <= widget.OTP_digitsCount) {
          ///Condtion to forward the animation
          if (_OTPcontroller.text == null || oldOTPLength < newOTPLength) {
            _OTPentry[newOTPLength - 1] = _OTPcontroller.text[newOTPLength - 1];
            setState(() {});

            _animationController[newOTPLength - 1].value = 0;
            _animationController[newOTPLength - 1].forward();
          }

          ///Condtion to reverse the animation
          else if (oldOTPLength > newOTPLength) {
            setState(() {});

            _animationController[oldOTPLength - 1].reverse();
          }
        }

        ///boundry conditon
        if (newOTPLength == 0) {
          if (_OTPcontroller.text == null ||
              oldOTPLength > _OTPcontroller.text.length) {
            setState(() {});

            _animationController[oldOTPLength - 1].reverse();
          }
        } else {
          _OTPentry[newOTPLength - 1] = _OTPcontroller.text[newOTPLength - 1];
          setState(() {});
        }

        oldOTPLength = newOTPLength;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    print("inti");

    ///maximum value of otp digits can be 8
    if (widget.OTP_digitsCount > 8) widget.OTP_digitsCount = 8;

    ///minimum value of otp digits can be 1
    if (widget.OTP_digitsCount <= 0) widget.OTP_digitsCount = 1;
    idx = 0;
    _OTPcontroller = new TextEditingController();
    _OTPfocusnode = new FocusNode();

    _animationController =
        new List<AnimationController>(widget.OTP_digitsCount);
    _animation = new List<Animation>(widget.OTP_digitsCount);

    for (int i = 0; i < widget.OTP_digitsCount; i++) {
      _animationController[i] = new AnimationController(
          vsync: this,
          duration: widget.animation != TextAnimation.None
              ? widget.duration
              : const Duration(microseconds: 1));

      _animation[i] = new Tween<double>(end: 1, begin: 0).animate(
          CurvedAnimation(
              parent: _animationController[i],
              curve: widget.forwardCurve,
              reverseCurve: widget.reverseCurve))
        ..addListener(() {
          if (widget.animation == TextAnimation.Rotation) setState(() {});
        });
    }

    /// creating list to show text (otp)
    _OTPentry = new List(widget.OTP_digitsCount);

    /// assigning intial value to _otpentry this to forward and reverse the animation easily
    for (int i = 0; i < widget.OTP_digitsCount; i++) _OTPentry[i] = "~";

    ///Number of total widgetts in row will be this.
    _textfield = new List(widget.OTP_digitsCount * 2 - 1);

    _OTPcontroller.addListener(() {
      final newOTPLength = _OTPcontroller.text.length;
      widget.textEditingController.text = _OTPcontroller.text;

      if (newOTPLength > 0 && newOTPLength <= widget.OTP_digitsCount) {
        ///Condtion to forward the animation
        if (_OTPcontroller.text == null || oldOTPLength < newOTPLength) {
          _OTPentry[newOTPLength - 1] = _OTPcontroller.text[newOTPLength - 1];
          setState(() {});

          _animationController[newOTPLength - 1].value = 0;
          _animationController[newOTPLength - 1].forward();
        }

        ///Condtion to reverse the animation
        else if (oldOTPLength > newOTPLength) {
          setState(() {});

          _animationController[oldOTPLength - 1].reverse();
        }
      }

      ///boundry conditon
      if (newOTPLength == 0) {
        if (_OTPcontroller.text == null ||
            oldOTPLength > _OTPcontroller.text.length) {
          setState(() {});

          _animationController[oldOTPLength - 1].reverse();
        }
      } else {
        _OTPentry[newOTPLength - 1] = _OTPcontroller.text[newOTPLength - 1];
        setState(() {});
      }

      oldOTPLength = newOTPLength;
    });
    super.initState();
  }

  @override
  void dispose() {
    _OTPcontroller.dispose();

    _OTPfocusnode.dispose();
    for (int i = 0; i < widget.OTP_digitsCount; i++)
      this._animationController[i].dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animationController.length);
    idx = 0;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          // color: Colors.black,
          width: 15,
          height: 15,
          child: TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            style: TextStyle(color: Colors.transparent),
            focusNode: _OTPfocusnode,
            controller: _OTPcontroller,
            maxLengthEnforced: true,
            maxLength: widget.OTP_digitsCount,
            showCursor: false,
            autofocus: widget.autoFocus,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              counter: SizedBox.shrink(),
            ),
          ),
        ),
        Container(
          height: 15,
          width: 30,
          color: Colors.transparent,
        ),
        GestureDetector(
          onTap: () {
            if (!_OTPfocusnode.hasFocus)
              FocusScope.of(context).requestFocus(_OTPfocusnode);
            if (_OTPfocusnode.hasFocus) FocusScope.of(context).unfocus();

            SystemChannels.textInput.invokeMethod('TextInput.show');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _textfield.map((e) {
              if (idx % 2 == 0) {
                idx++;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.animation == TextAnimation.Sizing)
                      myContainer(
                        SizeTransition(
                          axis: Axis.horizontal,
                          sizeFactor: _animation[((idx - 1) / 2).round()],
                          child: myText(),
                        ),
                      ),
                    if (widget.animation == TextAnimation.Rotation)
                      myContainer(
                        Transform.rotate(
                          origin: const Offset(0.0, 0.0),
                          angle: 2 *
                              pi *
                              _animation[((idx - 1) / 2).round()].value,
                          child: ScaleTransition(
                            scale: _animation[((idx - 1) / 2).round()],
                            child: myText(),
                          ),
                        ),
                      ),
                    if (widget.animation == TextAnimation.Scaling ||
                        widget.animation == TextAnimation.None)
                      myContainer(
                        ScaleTransition(
                          scale: _animation[((idx - 1) / 2).round()],
                          child: myText(),
                        ),
                      ),
                    if (widget.animation == TextAnimation.Fading)
                      myContainer(
                        FadeTransition(
                          opacity: _animation[((idx - 1) / 2).round()],
                          child: myText(),
                        ),
                      ),
                  ],
                );
              } else {
                idx++;
                return SizedBox(
                  width: widget.spaceBetweenFields,
                );
              }
            }).toList(),
          ),
        )
      ],
    );
  }

  ///Widget to show border or container arount the otp fields.
  Widget myContainer(Widget child) {
    return Container(
        padding: widget.contentPadding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: widget.border,
          color: widget.fieldBackgroungColor,
        ),
        height: widget.fieldHeight,
        width: widget.fieldWidth,
        constraints: BoxConstraints(
          minHeight: 30.0,
          minWidth: 30.0,
        ),
        child: child);
  }

  ///Widget to display the otp
  Widget myText() {
    return Text(
      !widget.obscureText
          ? _OTPentry[((idx - 1) / 2).round()].toString()
          : widget.obscureCharacter,
      textAlign: TextAlign.center,
      style: widget.textStyle,
    );
  }
}
