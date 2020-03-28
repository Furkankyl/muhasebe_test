import 'package:flutter/material.dart';

import 'app/screens/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Poetsen',

          textTheme: TextTheme(
            subtitle: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.white, fontFamily: 'Poetsen'),
            body1: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.white, fontFamily: 'Poetsen'),
            title: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white, fontFamily: 'Poetsen'),
          ),

          scaffoldBackgroundColor: Color.fromRGBO(145, 104, 222, 1),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          accentColor: Color.fromRGBO(145, 104, 222, 1)),
      home: SplashScreen(),
    );
  }
}



