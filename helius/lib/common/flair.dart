import 'package:flutter/cupertino.dart';

class Flair extends StatelessWidget {
  final String flairText;

  Flair({@required this.flairText});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(flairText, style: TextStyle(fontSize: 12)),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CupertinoColors.lightBackgroundGray));
  }
}
