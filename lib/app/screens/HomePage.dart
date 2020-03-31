import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/model/User.dart';
import 'package:muhasebetest/app/screens/AddFilePage.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/locator.dart';

import 'AccountPage.dart';
import 'FilesPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  var _controller = PageController();

  Map<DateTime, List<FileModel>> map = Map();
  bool busy = true;

  @override
  void initState() {
    fetchMap();
    super.initState();
  }

  fetchMap() async {
    DBService db = locator<DBService>();

    await db.getFiles(DateTime.now(), 5);
    map = db.data;
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        onPressed: () async {

          FileModel file = await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddFilePage(

                  )));
          print(file);
          if (file != null) {
            await Future.delayed((Duration(milliseconds: 1000)));
            if (map
                .containsKey(DateTime(file.date.year, file.date.month))) {
              map[DateTime(file.date.year, file.date.month)].add(file);

            } else {
              map.addAll({
                file.date: [file]
              });
            }

            setState(() {});
          }
          //db.fileInsert(FileModel(id: 0,name: "mart dökümanı",url: "yok",date: DateTime(2020,3,15),editingDate: DateTime(2020,3,15)));
          // db.getFiles(DateTime(2020,3), 5);
        },
        child: Icon(Icons.add),
        elevation: 8,
        highlightElevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: new BubbleBottomBar(
        hasInk: true,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        inkColor: Color.fromRGBO(145, 104, 222, 1),
        opacity: 1,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex != index) {
            setState(() {
              switch (index) {
                case 0:
                  _controller.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
                  break;
                case 1:
                  _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
              }
              _selectedIndex = index;
            });
          }
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.insert_drive_file,
                color: Colors.deepPurple,
              ),
              activeIcon: Icon(
                Icons.insert_drive_file,
                size: 32,
                color: Colors.white,
              ),
              title: Text(
                "Dosyalar",
                style: TextStyle(color: Colors.white),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.person,
                color: Colors.deepPurple,
              ),
              activeIcon: Icon(
                Icons.person,
                size: 32,
                color: Colors.white,
              ),
              title: Text(
                "Hesabım",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: new PageView(
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          busy
              ? Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : FilesPage(map),
          AccountPage(),
        ],
      ),
    );
  }
}
