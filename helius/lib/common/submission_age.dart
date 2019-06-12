import 'package:flutter/cupertino.dart';

class SubmissionAge extends StatelessWidget {
  final DateTime createdUtc;

  SubmissionAge({@required this.createdUtc});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.clock,
            size: 12,
          ),
          Text(
            _formattedAge(_age(createdUtc)),
            style: TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }

  Duration _age(DateTime given) => DateTime.now().difference(given);

  String _formattedAge(Duration age) {
    if (age.inDays > 0) {
      return '${age.inDays.toString()}d';
    } else if (age.inHours > 0) {
      return '${age.inHours.toString()}h';
    } else if (age.inMinutes > 0) {
      return '${age.inMinutes.toString()}m';
    } else {
      return '${age.inSeconds.toString()}s';
    }
  }
}
