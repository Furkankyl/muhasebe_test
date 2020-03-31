import 'package:auto_animated/auto_animated.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/screens/AddFilePage.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/app/widgets/EmptyFileWidget.dart';
import 'package:muhasebetest/app/widgets/FileWidget.dart';
import 'package:muhasebetest/locator.dart';

class FilesPage extends StatefulWidget {
  final Map<DateTime, List<FileModel>> map;

  FilesPage(this.map);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  int selectedIndex = 0;

  TabController tabController;

  @override
  void initState() {
    print('init');
    initializeDateFormatting('tr', null);

    tabController = TabController(vsync: this, length: widget.map.length);
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });

    super.initState();
  }

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
              tabs: widget.map.keys.map((date) {
                String dateString = DateFormat(
                        "${date.year == DateTime.now().year ? "" : "yyyy\n"}MMMM",
                        "tr_TR")
                    .format(date);
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
      length: widget.map.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              tabBar(),
              Expanded(
                  child: TabBarView(
                controller: tabController,
                children: widget.map.values.map((list) {
                  return list.isEmpty ? EmptyFileWidget() : fileList(list);
                }).toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget fileList(List<FileModel> fileList) {
    final options = LiveOptions(
      // Start animation after (default zero)
      delay: Duration(seconds: 1),

      // Show each item through (default 250)
      showItemInterval: Duration(milliseconds: 500),

      // Animation duration (default 250)
      showItemDuration: Duration(seconds: 1),

      // Animations starts at 0.05 visible
      // item fraction in sight (default 0.025)
      visibleFraction: 0.05,

      // Repeat the animation of the appearance
      // when scrolling in the opposite direction (default false)
      // To get the effect as in a showcase for ListView, set true
      reAnimateOnVisibility: false,
    );
    return LiveGrid(
      padding: EdgeInsets.all(16),
      showItemInterval: Duration(milliseconds: 300),
      showItemDuration: Duration(milliseconds: 500),
      visibleFraction: 0.001,
      itemCount: fileList.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: index == fileList.length
              ? Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        DateTime selectedDate = DateTime(DateTime.now().year,
                            DateTime.now().month - selectedIndex);

                        FileModel file =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AddFilePage(
                                      date: selectedDate,
                                    )));
                        print(file);
                        if (file != null) {
                          await Future.delayed((Duration(milliseconds: 1000)));
                          if (widget.map.containsKey(
                              DateTime(file.date.year, file.date.month))) {
                            widget
                                .map[DateTime(file.date.year, file.date.month)]
                                .add(file);
                            if (!selectedDate.isAtSameMomentAs(
                                DateTime(file.date.year, file.date.month))) {
                              setState(() {
                                selectedIndex = widget.map.keys
                                    .toList()
                                    .indexOf(DateTime(
                                        file.date.year, file.date.month));
                              });
                            }
                          } else {
                            widget.map.addAll({
                              file.date: [file]
                            });
                          }

                          setState(() {});
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icons/add.svg",
                            semanticsLabel: "asdasd",
                            height: 80,
                            width: 80,
                          ),
                          Text('Dosya ekle'),
                        ],
                      ),
                    ),
                  ),
                )
              : fileList[index].id == null
                  ? Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 10),
                            spreadRadius: 5,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: FlareActor("assets/anim/thrash.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "thrash"))
                  : FileWidget(
                      fileModel: fileList[index],
                      onDelete: deleteFile,
                      onUpdate: updateFile,
                    ),
        );
      },
    );
  }

  deleteFile(FileModel file) async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      widget
          .map[DateTime(file.date.year, file.date.month)][widget
              .map[DateTime(file.date.year, file.date.month)]
              .indexOf(file)]
          .id = null;
    });
    await Future.delayed(Duration(seconds: 3));

    widget.map[DateTime(file.date.year, file.date.month)].remove(file);
    setState(() {});
  }

  updateFile(FileModel fileModel) async {
    print(fileModel);
    widget.map.keys.forEach((key) {
      widget.map[key].forEach((file){

          if (fileModel.id == file.id) {
            widget.map[DateTime(file.date.year, file.date.month)][widget.map[key].indexOf(
                file)]
            = fileModel;
            print("bulundu:"+file.toString());
          }
      });

    });
    setState(() {

    });
  }
}
