import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:muhasebetest/app/screens/FilePage.dart';

class FileWidget extends StatefulWidget {
  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this);
    _sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 2, end: .5),
            from: Duration(milliseconds: 200),
            to: Duration(milliseconds: 500),
            tag: "radius")
        .animate(_animationController);

    _animationController.forward().orCancel;

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: OpenContainer(
          transitionDuration: Duration(milliseconds: 800),
          closedBuilder: (context, _) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, widget) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 8,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return RadialGradient(
                            center: Alignment.topLeft,
                            radius: _sequenceAnimation['radius'].value,
                            colors: <Color>[
                              Colors.deepPurple,
                              Colors.blueAccent[200]
                            ],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.insert_drive_file,
                          size: 120,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Test1',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          openBuilder: (context, _) {
            return FilePage();
          },
        ),
      ),
    );
  }
}
