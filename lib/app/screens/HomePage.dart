import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/screens/AddFilePage.dart';
import 'package:muhasebetest/app/widgets/FileWidget.dart';

import 'AccountPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget currentWidget;

  var _controller = PageController();

  @override
  void initState() {
    currentWidget = FilesPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddFilePage()));
        },
        child: Icon(Icons.add),
        elevation: 8,
        highlightElevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: 0.8,
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
        //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Color.fromRGBO(145, 104, 222, 1),
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
              backgroundColor: Color.fromRGBO(145, 104, 222, 1),
              icon: Icon(
                Icons.person,
                color: Color.fromRGBO(145, 104, 222, 1),
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
      body: PageView(
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          FilesPage(),
          AccountPage(),
        ],
      ),
    );
  }
}

class FilesPage extends StatefulWidget {
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  DateTime date = DateTime.now();
  int selectedIndex = 0;

  @override
  void initState() {
    initializeDateFormatting('tr', null);
    super.initState();
  }

  Widget dateFilterWidget() {
    return Container(
      height: 100,
      child: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: EdgeInsets.all(4),
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String dateString = "";

                dateString = DateFormat("MMMM", "tr_TR").format(
                    new DateTime(date.year, date.month - index, date.day));

                return montWidget(dateString.substring(0, 3), index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget montWidget(String title, index) {
    Color color = index == selectedIndex ? Colors.white : Colors.blue;
    Color backgroundColor = index == selectedIndex ? Colors.blue : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Card(
        elevation: 8,
        color: backgroundColor,
        child: Container(
          height: 75,
          width: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.note_add,
                color: color,
              ),
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyWidget() => Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    return RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1,
                      colors: <Color>[
                        Colors.greenAccent[200],
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
                SizedBox(
                  height: 32,
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      'Burada hiç dosya yok',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  subtitle: Text(
                    'Dosya ekle veya başka bir ay seç',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            dateFilterWidget(),
            Expanded(
              child: selectedIndex == 0
                  ? emptyWidget()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        crossAxisCount: 2,
                        children: <Widget>[
                          FileWidget(),
                          FileWidget(),
                          FileWidget(),
                          FileWidget(),
                          FileWidget(),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
