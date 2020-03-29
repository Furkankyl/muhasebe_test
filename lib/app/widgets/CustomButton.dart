import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final bool createAnim;
  final Color color;
  final Color textColor;

  CustomButton(
      {@required this.child, @required this.onPressed, this.createAnim = true,this.color = Colors.white,this.textColor = Colors.deepPurple});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this);
    _sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 60),
            from: Duration(seconds: 1),
            to: Duration(milliseconds: 1300),
            tag: "blink")

        .animate(_animationController);

    if (widget.createAnim) {

      _animationController.forward().orCancel;
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context,_){
        return Container(
          height: widget.createAnim?_sequenceAnimation['blink'].value:60,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: RaisedButton(
            color: widget.color,

            textColor: widget.textColor,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(255.0),
            ),
            elevation: 10,
            splashColor: Colors.transparent,
            highlightElevation: 0,
            highlightColor: Colors.transparent,
            child: widget.child,
            onPressed: widget.onPressed,
          ),
        );
      },
    );
  }
}
