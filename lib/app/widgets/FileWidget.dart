
import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 16,
      child: InkWell(
        onTap: (){

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1,
                  colors: <Color>[
                    Colors.deepPurple,
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
            Text('Test'),
          ],
        ),
      ),
    );
  }
}
