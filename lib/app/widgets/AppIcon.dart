
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "app_icon",
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (_) {
          return RadialGradient(
              center: Alignment.center,
              tileMode: TileMode.repeated,
              radius: .8,
              colors: [
                Colors.lightBlue,
                Colors.white.withOpacity(0.8),
              ]).createShader(_);
        },
        child: Icon(
          Icons.insert_drive_file,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
