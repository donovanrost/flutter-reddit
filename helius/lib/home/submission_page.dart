import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/app_provider.dart';
import 'package:helius/common/botton.dart';
import 'package:helius/home/routing_message.dart';
import 'package:helius/home/submission_provider.dart';
import 'package:helius/home/subreddit_list_item.dart';
import 'package:helius/home/subreddit_provider.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:rxdart/subjects.dart';
import 'package:helius/common/loading_indicator.dart';

class SubmissionPage extends StatefulWidget {
  // RoutingMessage message;

  SubmissionPage(/*{@required this.message}*/);
  @override
  _SubmissionPageState createState() => _SubmissionPageState(/*message*/);
}

class _SubmissionPageState extends State<SubmissionPage> {
  var bloc;
  var rebuildCounter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = SubmissionProvider.of(context);

    MaterialButton();
    return SafeArea(
      top: false,
      child: CupertinoPageScaffold(
          // child: Center(child: Text('asd'))
          child: _submissionPage(context)),
    );
  }

  Widget _submissionPageNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      key: GlobalKey(),
      largeTitle:
          Text('[Submission page placeholder]'), //Text(message.subredditName),
      previousPageTitle: '[Placeholder]', //message.previousPage,
    );
  }

  Widget _submissionInfoArea(BuildContext context) {
    return SliverToBoxAdapter(child: SubmissionActionBar());
  }

  Widget _submissionPage(BuildContext context) {
    List<Widget> _slivers = [];

    _slivers.add(_submissionPageNavigationBar(context));
    _slivers.add(_submissionInfoArea(context));

    return CustomScrollView(slivers: _slivers);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class SubmissionActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _divider(),
        Padding(
          padding: EdgeInsets.only(bottom: 6),
        ),
        _buttonRow(),
        Padding(
          padding: EdgeInsets.only(top: 6),
        ),
        _divider()
      ],
    );
  }

  _divider() {
    return Container(
      height: 1,
      color: CupertinoColors.lightBackgroundGray,
    );
  }

  _buttonRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Button(
            onTap: () => print('hi'),
            color: CupertinoColors.activeOrange,
            iconData: CupertinoIcons.up_arrow,
            size: 40),
        Button(
            onTap: () => print('hi'),
            color: CupertinoColors.destructiveRed,
            iconData: CupertinoIcons.down_arrow,
            size: 40),
        Button(
            onTap: () => print('hi'),
            color: CupertinoColors.activeGreen,
            iconData: CupertinoIcons.tag,
            size: 40),
        Button(
            onTap: () => print('hi'),
            color: CupertinoColors.activeOrange,
            iconData: CupertinoIcons.reply,
            animate: false,
            size: 40),
        Button(
            onTap: () => print('hi'),
            color: CupertinoColors.activeOrange,
            iconData: CupertinoIcons.share,
            animate: false,
            size: 40),
      ],
    );
  }
}
