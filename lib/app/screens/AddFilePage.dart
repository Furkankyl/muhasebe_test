import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/locator.dart';
import 'package:open_file/open_file.dart';

class AddFilePage extends StatefulWidget {

  DateTime date;

  AddFilePage({this.date});

  @override
  _AddFilePageState createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  File _file;
  bool isValid = false;
  DateTime date = DateTime.now();
  String fileExtension = "";
  var fileNameController = TextEditingController();

  bool isLoading = false;
  bool isComplete = false;

  double progress = 0;

  @override
  void initState() {
    if(widget.date != null)
      date = widget.date;
    initializeDateFormatting('tr', null);
    super.initState();
  }

  addFile() async {
    setState(() {
      isLoading = true;
    });
    DBService db = locator<DBService>();

    FileModel fileModel = FileModel(
        name: fileNameController.text+fileExtension,
        url: await uploadFile((await db.getCurrentUser()).id),
        date: date,
        editingDate: DateTime.now());



    int fileId = await db.fileInsert(fileModel);
    if (fileId != null) {
      setState(() {
        isComplete = true;
      });
      fileModel.id = fileId;
      Future.delayed(Duration(seconds: 2)).then((_){
        Navigator.of(context).pop(fileModel);

      });
    }
  }

  Future<dynamic> uploadFile(userId) async {
    final StorageReference storageReference = FirebaseStorage().ref().child(
        "/Users/$userId/Belgeler/${DateFormat("yyyy").format(date)}/${DateFormat("MMMM", "tr_TR").format(date)}/${fileNameController.text+fileExtension}");

    final StorageUploadTask uploadTask = storageReference.putFile(_file);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
      print(
          'byTransfer:  ${event.snapshot.bytesTransferred.toDouble()} / ${event.snapshot.totalByteCount.toDouble()}');

      print(
          'Transfer : ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}');
      setState(() {
        progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        /* progressValues[index] = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        if (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble() ==
            1) lastProccess = "${filesNames[index]}   yüklendi";*/
      });
    });

// Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
    return storageReference.getDownloadURL();
  }

  validate() {
    setState(() {
      isValid = _file != null &&
          fileNameController.text.isNotEmpty &&
          fileNameController.text.length >= 3;
    });
  }

  Widget loadingWidget() {
    return Center(
      child: isComplete?Column(
        children: <Widget>[
          Container(
              height: 250,
              width: 250,
              child: FlareActor("assets/anim/check.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "check_animation")),
          SizedBox(height: 16,),
          Text('Dosya eklendi'),
        ],
      ):Card(
        elevation: 10,
        child: ListTile(
          title: Text('Dosya yükleniyor', style: TextStyle(color: Colors.deepPurple)),
          subtitle: LinearProgressIndicator(
            value: progress,
          ),
          trailing: Text('%${(progress * 100).toStringAsFixed(0)}',style: TextStyle(color: Colors.deepPurple),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading?null:FloatingActionButton.extended(
          backgroundColor: isValid ? Colors.deepPurple : Colors.grey,
          disabledElevation: 0,
          heroTag: "fab",
          onPressed: isValid ? addFile : null,
          label: Text('Ekle')),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Dosya ekle'),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: isLoading
            ? loadingWidget()
            : SafeArea(
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                            child: ListTile(
                          title: Text('Dosya:',
                              style: Theme.of(context).textTheme.title),
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
                                              print(_file.path.split("/").last);
                                              fileExtension = "." +
                                                  _file.path
                                                      .split("/")
                                                      .last
                                                      .split(".")
                                                      .last;
                                            });
                                            validate();
                                          }
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SvgPicture.asset(
                                            "assets/icons/${_file != null ? "file.svg" : "add.svg"}",
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                        Text(
                                          _file != null
                                              ? "dosya"
                                              : 'Dosya seçilmedi',
                                          style: TextStyle(
                                              color: Colors.deepPurple),
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
                    SizedBox(
                      height: 8,
                    ),
                    ListTile(
                      title: Text(
                        "Tarih:",
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(DateFormat("yyyy-MM-dd").format(date),
                          style: Theme.of(context).textTheme.subtitle),
                      trailing: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/calendar.svg",
                          height: 48,
                          width: 48,
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              this.date = date;
                            });
                            validate();
                          }, currentTime: date, locale: LocaleType.tr);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fileNameController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 32,
                        maxLengthEnforced: true,
                        onFieldSubmitted: (term) {
                          if(isValid)
                          addFile();
                        },
                        onChanged: (text) {
                          validate();
                        },
                        autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "boş bırakılamaz.";
                          } else if (value.length < 3) {
                            return "Dosya adı en az 3 haneli olmalıdır!";
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
                          counterStyle: TextStyle(color: Colors.white),
                          labelText: "Dosya adı",
                          hintText: "muhasebe raporu",
                          suffixText: fileExtension,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
