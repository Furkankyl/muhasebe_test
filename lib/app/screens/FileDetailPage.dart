import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/screens/EditFilePage.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:muhasebetest/app/widgets/CustomDialog.dart';
import 'package:muhasebetest/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDetailPage extends StatefulWidget {
  FileModel fileModel;
  final Function onDelete;
  final Function onUpdate;

  FileDetailPage({@required this.fileModel, @required this.onDelete,@required this.onUpdate});

  @override
  _FileDetailPageState createState() => _FileDetailPageState(fileModel);
}

class _FileDetailPageState extends State<FileDetailPage> {
  FileModel _fileModel;

  _FileDetailPageState(this._fileModel);

  bool isEditingMode = false;

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
                            _fileModel.name,
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
                          TextSpan(
                              text: DateFormat("yyyy-MM-dd HH:mm")
                                  .format(_fileModel.date)),
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
                          TextSpan(
                              text: DateFormat("yyyy-MM-dd HH:mm")
                                  .format(_fileModel.editingDate)),
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
                    onPressed: () async {
                      /*
                      const url =
                          'https://firebasestorage.googleapis.com/v0/b/malware-74bed.appspot.com/o/Users%2F1%2FBelgeler%2FLogo?alt=media&token=f03ac197-5904-4908-bcd8-1eb62d58a9c0';
*/
                      if (await canLaunch(_fileModel.url)) {
                        await launch(_fileModel.url);
                      } else {
                        throw 'Could not launch ${_fileModel.url}';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    child: Text('Düzenle'),
                    onPressed: () async {
                      FileModel file = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  EditFilePage(fileModel: _fileModel)));

                      if (file != null) {
                        print(file);
                        setState(() {
                          _fileModel = file;
                        });
                        widget.onUpdate(file);
                      }
                    },
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
                                  buttonAcceptEvent: delete,
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
  delete() async {
    DBService db = locator<DBService>();

    bool result = await db.fileRemove(widget.fileModel.id);

    Navigator.of(context).pop();
    widget.onDelete(widget.fileModel);

  }
}
