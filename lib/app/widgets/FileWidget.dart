import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/screens/FileDetailPage.dart';

class FileWidget extends StatefulWidget {

  final FileModel fileModel;
  final Function onDelete;
  final Function onUpdate;

  FileWidget({@required this.fileModel,@required this.onDelete,@required this.onUpdate});

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
              builder: (context, _) {
                return Column(
                  children: <Widget>[
                    Expanded(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.fileModel.name,
                        maxLines: 2,
                        overflow: TextOverflow.fade,

                        style:
                            TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          openBuilder: (context, _) {
            return FileDetailPage(fileModel:widget.fileModel,onDelete: widget.onDelete,onUpdate: widget.onUpdate,);
          },
        ),
      ),
    );
  }
}
