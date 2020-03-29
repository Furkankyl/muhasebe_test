import 'package:flutter/material.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:muhasebetest/app/widgets/CustomDialog.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 16,
              left: 16,
              child: BackButton(
                color: Colors.white70,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 64,
                  ),
                  Card(
                    elevation: 16,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) {
                              return RadialGradient(
                                center: Alignment.topLeft,
                                radius: 1,
                                colors: <Color>[
                                  Colors.deepPurple,
                                  Colors.blueAccent[200]
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: Icon(
                              Icons.insert_drive_file,
                              size: 120,
                            ),
                          ),
                          Text(
                            'Test1',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.body1,
                        children: [
                          TextSpan(
                              text: "Oluşturulma tarihi:\t\t",
                              style: TextStyle(color: Colors.white70)),
                          TextSpan(text: "29.03.2020 13:30"),
                        ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.body1,
                        children: [
                          TextSpan(
                              text: "Son değişiklik:\t\t",
                              style: TextStyle(color: Colors.white70)),
                          TextSpan(text: "29.03.2020 13:30"),
                        ]),
                  ),
                  Spacer(),
                  Spacer(),
                ],
              ),
            ),
            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  CustomButton(
                    child: Text('Aç'),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    child: Text('Düzenle'),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.delete),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Sil'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            var begin = Offset(0, 1);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);

                            return FadeTransition(
                                opacity: animation,
                                child: CustomDialog(
                                  buttonAccept: "Sil",
                                  title: "Dikkat",
                                  buttonAcceptEvent: delete(),
                                  content:
                                      'Bu dosyayı kalıcı olarak silmek istediğine emin misin?',
                                ));
                          }));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //TODO delete event add
  Future<bool> delete() async{
    await Future.delayed(Duration(seconds: 3));
    print("silindi");
  }
}
