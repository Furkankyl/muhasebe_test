import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:muhasebetest/app/helper/CustomToast.dart';
import 'package:muhasebetest/app/screens/SignInPage.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/app/widgets/AppIcon.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:muhasebetest/locator.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with TickerProviderStateMixin {
  var _formKey = GlobalKey<FormState>();

  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  bool keyboardIsVisible = false;
  GlobalKey stickyKey = GlobalKey();
  FocusNode passwordNode = FocusNode();
  FocusNode passwordConfirmNode = FocusNode();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var obscurePassword = true;
  var obscureConfirmPassword = true;

  var formIsValid = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
        animatable: Tween<double>(begin: 0, end: 1),
        from: Duration(milliseconds: 300),
        to: Duration(milliseconds: 800),
        tag: "opacityId")
        .addAnimatable(
        animatable: Tween<double>(begin: 0, end: 1),
        from: Duration(milliseconds: 300),
        to: Duration(milliseconds: 800),
        tag: "opacityUserName")
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

  bool isBusy = false;

  signUp() async {
    DBService auth = locator<DBService>();
    setState(() {
      isBusy = true;
    });
    bool result = await auth.changePassword(passwordController.text);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isBusy = false;
    });
    if (result) {
      CustomToast.showCard(
        title: "Şifren değişti",
      );
      Navigator.of(context).pop();
    }
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
                        key: _formKey,
                        onChanged: () {
                          setState(() {
                            formIsValid = _formKey.currentState.validate();
                          });
                        },
                        child: Column(
                          children: <Widget>[
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
                                  obscureText: obscurePassword,
                                  validator: (password) {
                                    if (password.isEmpty)
                                      return "boş bırakılamaz.";
                                    else if (password.length < 8)
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
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      errorStyle:
                                      TextStyle(color: Colors.white),
                                      counterStyle:
                                      TextStyle(color: Colors.white),
                                      labelText: "Parola",
                                      hintText: "12345678",
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            obscurePassword
                                                ? FontAwesomeIcons.solidEye
                                                : FontAwesomeIcons
                                                .solidEyeSlash,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              obscurePassword =
                                              !obscurePassword;
                                            });
                                          },
                                        ),
                                      )),
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
                                  obscureText: obscureConfirmPassword,
                                  validator: (password) {
                                    if (password.isEmpty)
                                      return "boş bırakılamaz.";
                                    else if (password.length < 8)
                                      return "parola en az 8 karakter olmalı";
                                    //TODO least one Uppercase and one lower case and one numeric
                                    else if (password !=
                                        passwordController.text)
                                      return "parolalar uyuşmuyor";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  focusNode: passwordConfirmNode,
                                  onFieldSubmitted: (term) {
                                    if (_formKey.currentState.validate())
                                      signUp();
                                  },
                                  decoration: InputDecoration(
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      errorStyle:
                                      TextStyle(color: Colors.white),
                                      counterStyle:
                                      TextStyle(color: Colors.white),
                                      labelText: "Parola doğrulama",
                                      hintText: "12345678",
                                      labelStyle:
                                      TextStyle(color: Colors.white),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            obscureConfirmPassword
                                                ? FontAwesomeIcons.solidEye
                                                : FontAwesomeIcons
                                                .solidEyeSlash,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              obscureConfirmPassword =
                                              !obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                      )),
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
                  child: SizedBox(
                    key: stickyKey,
                    child: CustomButton(
                      child: isBusy
                          ? CircularProgressIndicator()
                          : Text('Değiştir'),
                      onPressed: formIsValid ? signUp : null,
                    ),
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
