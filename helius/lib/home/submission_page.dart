import 'dart:async';

import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/app_provider.dart';
import 'package:helius/common/botton.dart';
import 'package:helius/common/navbar.dart';
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
    bloc.loadHotFor();
    return SafeArea(
      top: false,
      child: CupertinoPageScaffold(
          navigationBar: CustomCupertinoNavigationBar(
            key: new UniqueKey(),
            onTap: () => null,
            middle: Text('asd'),
          ),
          child: SafeArea(child: _submissionPage(context))),
    );
  }

  Widget _commentList(BuildContext context) {
    return StreamBuilder(
        stream: bloc.comments,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: LoadingIndicator()),
                  childCount: 1),
            );
          } else if (snapshot.hasError) {
            return SliverList(
              delegate: SliverChildListDelegate([]),
            );
          } else {
            // print(snapshot.data[1].toString());
            return SliverList(
                delegate: SliverChildListDelegate(_list(snapshot.data)));
          }
        });
  }

  List<Widget> _list(List comments) {
    return comments
        .map<Widget>((m) =>
            (m is Comment) ? _Comment(comment: m) : Text('More Comments'))
        .toList();
  }

  // Widget _comment(BuildContext context, comment) {
  //   if (comment is MoreComments) {
  //     print(comment.toString());
  //     return Text('More Comments');
  //   } else {
  //     return Text(comment.upvotes.toString());
  //   }
  // }

  Widget _submissionImage(BuildContext context, submission) {
    print(submission.preview[0].source.url);
    return SliverToBoxAdapter(
        child: Image.network(submission.preview[0].source.url.toString()));
  }

  Widget _submissionInfoArea(BuildContext context) {
    return SliverToBoxAdapter(child: SubmissionActionBar());
  }

  Widget _submissionPage(BuildContext context) {
    List<Widget> _slivers = [];

    _slivers.add(_submissionImage(context, this.bloc.submission));
    _slivers.add(_submissionInfoArea(context));
    _slivers.add(_commentList(context));

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

class _Comment extends StatelessWidget {
  final Comment comment;
  // List<Widget> comments = [];

  _Comment({
    @required this.comment,
  });

  // List<Widget> _test(comment) {
  //   if (comment.replies != null) {
  //     return comment?.replies?.comments
  //         ?.map<Widget>((c) =>
  //             (c is Comment) ? _Comment(comment: c) : Text('More Comments'))
  //         ?.toList();
  //   } else {
  //     return [SizedBox.shrink()];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _test(this.comment);
    return Padding(
      padding: EdgeInsets.only(left: 4.0 * this.comment.depth),
      child: Text('${this.comment.depth} -- ${this.comment.body}'),
    );
  }
}
