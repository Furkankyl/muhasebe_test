import 'package:flutter/material.dart';
import 'package:muhasebetest/app/helper/CustomSharedPref.dart';
import 'package:muhasebetest/app/model/User.dart';
import 'package:muhasebetest/app/screens/AccountFormPage.dart';
import 'package:muhasebetest/app/screens/ChangePasswordPage.dart';
import 'package:muhasebetest/app/screens/SplashScreen.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:muhasebetest/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User _user;
  @override
  void initState() {
    // TODO: implement initState
    fetchUser();

    super.initState();
  }

  fetchUser() async {
    DBService db = locator<DBService>();
    User user = await db.getCurrentUser();

    setState(() {
      this._user = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(145, 104, 222, 1),
        title: Text('Hesabım'),
      ),
      body: _user == null?Center(
        child: Card(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),),
      ):ListView(
        children: <Widget>[
          CustomButton(
            child: Text('Hesabı düzenle'),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AccountFormPage()));
            },
          ),          SizedBox(height: 16,),

          CustomButton(
           child: Text('Şifre değiştir'),
           onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ChangePasswordPage()));

           },
         ),          SizedBox(height: 16,),

          CustomButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text('Çıkış yap'),
            onPressed: ()async{
              SharedPref sp =
              SharedPref(await SharedPreferences.getInstance());
              sp.signOut();

              Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SplashScreen()));
            },
          )
        ],
      ),
    );
  }
}
