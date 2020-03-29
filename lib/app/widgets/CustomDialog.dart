import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final String buttonAccept;
  final String buttonCancel;
  final Future<void> buttonAcceptEvent;
  final Future<void> buttonCancelEvent;

  CustomDialog(
      {@required this.title,
      this.content = "",
      @required this.buttonAccept,
      this.buttonCancel = "iptal",
      @required this.buttonAcceptEvent,
      this.buttonCancelEvent});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(_controller);

    _offsetFloat.addListener(() {
      setState(() {});
    });

    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: SlideTransition(
        position: _offsetFloat,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if (widget.buttonCancelEvent != null)
                                await widget.buttonCancelEvent;

                              _controller.reverse().orCancel;
                              _controller.addStatusListener((status) {
                                print(status);
                                if (status == AnimationStatus.dismissed)
                                  Navigator.of(context).pop();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'iptal',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16))),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16)),
                            onTap: () async {
                              if (widget.buttonAcceptEvent != null)
                                await widget.buttonAcceptEvent;

                              _controller.reverse().orCancel;
                              _controller.addStatusListener((status) {
                                print(status);
                                if (status == AnimationStatus.dismissed)
                                  Navigator.of(context).pop();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Sil',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
