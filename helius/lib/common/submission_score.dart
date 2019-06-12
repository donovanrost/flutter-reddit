import 'package:flutter/cupertino.dart';

class SubmissionScore extends StatelessWidget {
  final int score;

  SubmissionScore({@required this.score});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.up_arrow,
            size: 12,
          ),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
