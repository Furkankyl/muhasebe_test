import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:muhasebetest/app/widgets/AppIcon.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  bool keyboardIsVisible = false;
  GlobalKey stickyKey = GlobalKey();
  FocusNode passwordNode = FocusNode();
  FocusNode passwordConfirmNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 300),
            to: Duration(milliseconds: 800),
            tag: "opacityEmail")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 800),
            to: Duration(milliseconds: 1300),
            tag: "opacityPassword")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 1300),
            to: Duration(milliseconds: 1800),
            tag: "opacityConfirm")
        .animate(controller);

    controller.forward().orCancel;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);

        setState(() {
          keyboardIsVisible = visible;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          AppIcon(),
                          Hero(
                            tag: "app_name",
                            transitionOnUserGestures: true,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                'Muhasebele',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 64,
                      ),
                      Form(
                        child: Column(
                          children: <Widget>[
                            Opacity(
                              opacity: sequenceAnimation['opacityEmail'].value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  onFieldSubmitted: (term) {
                                    FocusScope.of(context)
                                        .requestFocus(passwordNode);
                                  },
                                  autovalidate: true,
                                  validator: (value) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);

                                    bool emailValid = regex.hasMatch(value);
                                    if (value.isEmpty) {
                                      return "boş bırakılamaz.";
                                    } else if (!emailValid) {
                                      return "geçersiz mail adresi!";
                                    } else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    labelText: "Email",
                                    hintText: "example@gmail.com",
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity:
                                  sequenceAnimation['opacityPassword'].value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  maxLength: 32,
                                  maxLengthEnforced: true,
                                  autovalidate: true,
                                  validator: (password) {
                                    if(password.isEmpty)
                                      return "boş bırakılamaz.";
                                    else if(password.length < 8)
                                      return "parola en az 8 karakter olmalı";
                                    //TODO least one Uppercase and one lower case and one numeric
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (term) {
                                    FocusScope.of(context)
                                        .requestFocus(passwordConfirmNode);
                                  },
                                  focusNode: passwordNode,
                                  decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    labelText: "Password",
                                    hintText: "example@gmail.com",
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity:
                                  sequenceAnimation['opacityConfirm'].value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  maxLength: 32,
                                  maxLengthEnforced: true,
                                  autovalidate: true,
                                  validator: (password) {

                                    if(password.isEmpty)
                                      return "boş bırakılamaz.";
                                    else if(password.length < 8)
                                      return "parola en az 8 karakter olmalı";
                                    //TODO least one Uppercase and one lower case and one numeric
                                    else if(password != passwordController.text)
                                      return "parolalar uyuşmuyor";
                                    else
                                      return null;
                                  },

                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  focusNode: passwordConfirmNode,
                                  onFieldSubmitted: (term) {
                                    print('Send data');
                                  },
                                  decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),
                                    labelText: "Confirm Password",
                                    hintText: "example@gmail.com",
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  left: 0,
                  right: 0,
                  bottom: keyboardIsVisible
                      ? -(stickyKey.currentContext.findRenderObject()
                              as RenderBox)
                          .size
                          .height
                      : 16,
                  child: LayoutBuilder(
                    builder: (context, builder) {
                      return SizedBox(
                        key: stickyKey,
                        child: CustomButton(
                          child: Text('Sign Up'),
                          onPressed: () {},
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
