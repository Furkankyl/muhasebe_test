import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyFileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}
