import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Hesabım'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Furkan Kayalı"),
          ),
          ListTile(
            title: Text('Hesabım'),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text("Şifre değiştir"),
          ),
          ListTile(
            leading: Icon(Icons.forward),
            title: Text("Google hesabını bağla"),
          ),
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 16),
              textColor: Colors.red,
              child: Text("Çıkış yap"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
