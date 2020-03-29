import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      bottomNavigationBar:new BubbleBottomBar(
        hasInk: true,
        hasNotch: true,
        fabLocation:BubbleBottomBarFabLocation.end,
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

class _FilesPageState extends State<FilesPage> with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  int selectedIndex = 0;

  TabController tabController;

  @override
  void initState() {
    initializeDateFormatting('tr', null);
    tabController = TabController(vsync: this, length: list.length );
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
    super.initState();
  }

  List<DateTime> list = [
    DateTime(2020, 3),
    DateTime(2020, 2),
    DateTime(2020, 1),
    DateTime(2019, 12),
    DateTime(2019, 11),
    DateTime(2019, 10),
    DateTime(2019, 9),
  ];

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
                SvgPicture.asset(
                    "assets/icons/not_found.svg",
                  semanticsLabel: "asdasd",
                  height: 150,
                  width: 150,
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

  Widget tabBar() => ClipRRect(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          foregroundDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(255)),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(255),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 5), //(
                spreadRadius: 2.5,
                blurRadius: 5,
              ),
            ],
          ),
          child: TabBar(
              controller: tabController,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              unselectedLabelColor: Colors.deepPurple,
              labelColor: Colors.white,
              isScrollable: true,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.deepPurple),
              tabs: list.map((date) {
                String dateString = DateFormat("MMMM", "tr_TR").format(date);
                return Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(dateString),
                    ),
                  ),
                );
              }).toList()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedIndex,
      length: list.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              tabBar(),
              Expanded(
                  child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  emptyWidget(),
                  tabbBarView(),
                  tabbBarView(),
                  tabbBarView(),
                  tabbBarView(),
                  tabbBarView(),
                  tabbBarView(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget tabbBarView() =>  Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            children: <Widget>[
              FileWidget(),
              FileWidget(),
              FileWidget(),
              FileWidget(),
              FileWidget(),
              FileWidget(),
              FileWidget(),
              Container(
                margin: EdgeInsets.all(16),

                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                SvgPicture.asset(
                "assets/icons/add.svg",
                  semanticsLabel: "asdasd",
                  height: 80,
                  width: 80,
                ),
                    Text(
                      'Dosya ekle'
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}
