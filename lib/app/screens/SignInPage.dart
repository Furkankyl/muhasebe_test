import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:muhasebetest/app/screens/HomePage.dart';
import 'package:muhasebetest/app/widgets/AppIcon.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  bool keyboardIsVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordNode = FocusNode();

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

  GlobalKey stickyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          AppIcon(),
                          Hero(
                            tag: "app_name",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                'Muhasebele',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Opacity(
                        opacity: sequenceAnimation['opacityEmail'].value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context).requestFocus(passwordNode);
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
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                              errorStyle: TextStyle(color: Colors.white),

                              labelText: "Email",
                              hintText: "example@gmail.com",
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: sequenceAnimation['opacityPassword'].value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            maxLength: 32,
                            maxLengthEnforced: true,
                            autovalidate: true,
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
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (term) {
                              print('Send datas');
                            },
                            focusNode: passwordNode,
                            decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                              errorStyle: TextStyle(color: Colors.white),
                              counterStyle: TextStyle(color: Colors.white),
                              labelText: "Password",
                              hintText: "example@gmail.com",
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Spacer(flex: 2,),
                    ],
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
                        return Column(
                          key: stickyKey,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomButton(
                              child: Text('Sign In'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage()));
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 32.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Giriş yaptığında ',
                                      style: TextStyle(color: Colors.white70)),
                                  TextSpan(
                                      text: 'kullanım koşullarını',
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          showPrivacyDialog(context);
                                        },
                                      style: TextStyle(
                                          decoration: TextDecoration.underline)),
                                  TextSpan(
                                      text: ' ve ',
                                      style: TextStyle(color: Colors.white70)),
                                  TextSpan(
                                      text: 'gizlilik politikasını',
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          showPrivacyDialog(context);
                                        },
                                      style: TextStyle(
                                          decoration: TextDecoration.underline)),
                                  TextSpan(
                                      text: ' kabul etmiş sayılırsın.',
                                      style: TextStyle(color: Colors.white70)),
                                ]),
                              ),
                            )
                          ],
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

  void showPrivacyDialog(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, animation, secondaryAnimation) {
          return ScaleTransition(
            alignment: Alignment.bottomCenter,
            scale: animation,
            child: PrivacyDialog(),
          );
        }));
  }
}

class PrivacyDialog extends StatefulWidget {
  @override
  _PrivacyDialogState createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends State<PrivacyDialog> {
  double shadowRadius = 0;
  bool isLoading = false;


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300))?.then((_) {
      setState(() {
        shadowRadius = 10;
        isLoading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: MediaQuery.of(context).size.width,
          height: isLoading ? MediaQuery.of(context).size.height : 120,
          margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(16),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, shadowRadius * 2), //(
                spreadRadius: shadowRadius,
                blurRadius: shadowRadius,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8,),
              ListTile(
                title: AutoSizeText(
                  'Privacy Policity',
                  maxLines: 1,
                  maxFontSize: 48,
                  minFontSize: 24,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque at efficitur ligula. Duis rhoncus risus vulputate, rhoncus justo in, tempus mi. Praesent imperdiet luctus nisl, eget hendrerit neque scelerisque non. Vivamus sed nibh ultricies, consectetur ante sit amet, gravida mauris. Etiam volutpat vitae odio suscipit facilisis. Curabitur maximus viverra pharetra. Phasellus ac tempor dui. Sed rutrum tellus leo, ac sollicitudin quam porttitor ullamcorper. Nam sit amet odio vitae tortor placerat condimentum et in nunc. Duis neque mauris, scelerisque et tempor quis, efficitur sed ipsum. Nam ullamcorper viverra rutrum. Phasellus vehicula nisi et pharetra sodales. Phasellus suscipit pellentesque augue, at pretium nunc consequat at. Suspendisse vestibulum dolor quam." +
                              "Donec porttitor euismod eros, ut volutpat ex sollicitudin et. Morbi tristique felis nibh, nec convallis est ornare ac. In vitae congue purus, et tempus mauris. Vivamus vehicula ligula sit amet leo varius consequat. Phasellus rutrum odio erat, vel malesuada elit fringilla vitae. In hac habitasse platea dictumst. Etiam elementum suscipit felis ut suscipit. In aliquam tortor imperdiet tortor convallis, ac rutrum risus eleifend. In quis nibh vitae neque semper posuere. Sed luctus ullamcorper maximus. Fusce accumsan urna laoreet, sodales sapien sit amet, consequat neque. Phasellus auctor molestie dui. Suspendisse eros leo, lobortis eget nisi sed, suscipit mattis urna. Mauris est ligula, gravida eget dapibus ut, ullamcorper id velit. Nullam tempus fringilla laoreet. Pellentesque dignissim dui non eros pellentesque bibendum." +
                              "Vivamus vulputate tortor nulla, et porta tortor mollis non. Phasellus commodo vitae ante nec molestie. Donec arcu lectus, lacinia vel elit at, cursus sollicitudin diam. Phasellus in luctus sem, a pretium est. Morbi efficitur nunc mi, ut egestas ligula iaculis eget. Suspendisse a mauris in dolor placerat ullamcorper nec dapibus velit. Donec non ex enim. Mauris tempus cursus bibendum." +
                              "Pellentesque at bibendum dolor. Vivamus sit amet sollicitudin elit. Nunc rutrum pulvinar faucibus. Morbi pulvinar ullamcorper mi, sit amet tristique mi egestas a. Donec euismod tempus neque, ac tristique nibh malesuada non. Cras semper eleifend mauris, eget aliquam ex aliquet elementum. Donec commodo leo scelerisque ex placerat, vitae suscipit mauris pulvinar. Etiam congue volutpat ante, in porta purus suscipit vitae. Proin vitae tempor leo. Nullam accumsan ipsum vel lorem finibus, ut tempor nunc finibus. Pellentesque vulputate lacus ut velit vehicula, et molestie lacus pretium." +
                              "Quisque a ligula et mi elementum dictum vitae et erat. Mauris ornare nunc ut arcu condimentum sollicitudin at eget diam. Nulla mattis ex ante, vel mattis velit porttitor quis. Aliquam eget nisl at odio ultrices condimentum vel in nunc. Donec lacus dui, egestas sed tortor tempor, aliquam malesuada turpis. Donec id diam a lectus porttitor pharetra vitae et lorem. Aliquam ultricies eros a neque luctus mattis.",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(255),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = false;
                            shadowRadius = 0;
                          });
                          Future.delayed(Duration(milliseconds: 500)).then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        borderRadius: BorderRadius.circular(255),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white70,
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
