import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:muhasebetest/app/helper/CustomSharedPref.dart';
import 'package:muhasebetest/app/screens/HomePage.dart';
import 'package:muhasebetest/app/screens/SignInPage.dart';
import 'package:muhasebetest/app/screens/SignUpPage.dart';
import 'package:muhasebetest/app/widgets/AppIcon.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isBusy = true;
  @override
  void initState() {
    checkLogin();

    super.initState();
  }

  checkLogin() async {
    await Future.delayed(Duration(milliseconds: 800));
    SharedPref sharedPref = SharedPref(await SharedPreferences.getInstance());
    print(sharedPref.isAuth());
    if (sharedPref.isAuth())
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (context, animation, _) {
        return FadeTransition(opacity: animation, child: HomePage());
      }));

    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isBusy? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),):SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 64,
            ),
            AppIcon(),
            Hero(
              tag: "app_name",
              transitionOnUserGestures: true,
              child: Material(
                type: MaterialType.transparency,
                child: AutoSizeText(
                  'Muhasebele',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Spacer(),
            CustomButton(
              child: Text(
                'KAYIT OL',
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SignUpPage()));
              },
            ),
            FlatButton(
              child: Text(
                'ZATEN HESABIM VAR',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SignInPage()));
              },
            ),
            SizedBox(
              height: 64,
            )
          ],
        ),
      ),
    );
  }
}
