import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';

class AddFilePage extends StatefulWidget {
  @override
  _AddFilePageState createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          heroTag: "fab",
          onPressed: () {},
          label: Text('Ekle')),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Dosya ekle'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 16,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: ListTile(
                      title: Text('Dosya:', style: Theme
                          .of(context)
                          .textTheme
                          .title),
                    )),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: Card(
                        child: InkWell(
                          onTap: _file != null
                              ? () {
                            //NOTE dosya varsa
                            print('dosya açılıyor');
                            OpenFile.open(_file.path);
                          }
                              : () async {
                            File pFile = await FilePicker.getFile(
                                fileExtension: ".pdf");

                            if (pFile != null) {
                              setState(() {
                                _file = pFile;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/${_file != null
                                        ? "contract1.svg"
                                        : "add.svg"}",
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                Text(
                                  _file != null ? "dosya" : 'Dosya seçilmedi',
                                  style: TextStyle(color: Colors.deepPurple),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Offstage(
                        offstage: _file == null,
                        child: Material(
                          borderRadius: BorderRadius.circular(255),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(255),
                            onTap: () {
                              setState(() {
                                _file = null;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8,),

            ListTile(
              title: Text(
                "Seçilen ay",
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
              ),
              subtitle: Text('2020 Mart ayı',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle),
              trailing: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/calendar.svg",
                  height: 48,
                  width: 48,
                ),
                onPressed: () {},
              ),
            ), SizedBox(height: 8,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Dosya adı",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    )),
              ),
            ), SizedBox(height: 8,),

          ],
        ),
      ),
    );
  }
}
