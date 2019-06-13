import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/common.dart';
import 'package:helius/home/submission_provider.dart';

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
        child: SafeArea(child: _submissionPage(context)),
      ),
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
                      child: LoadingIndicator(),
                    ),
                childCount: 1),
          );
        } else if (snapshot.hasError) {
          return SliverList(
            delegate: SliverChildListDelegate([]),
          );
        } else {
          // print(snapshot.data[1].toString());
          return SliverList(
            delegate: SliverChildListDelegate(_list(snapshot.data)),
          );
        }
      },
    );
  }

  List<Widget> _list(List comments) {
    return comments
        .map<Widget>(
          (m) => (m is Comment) ? _Comment(comment: m) : Text('More Comments'),
        )
        .toList();
  }

  Widget _submissionImage(BuildContext context, submission) {
    print(submission.preview[0].source.url);
    return SliverToBoxAdapter(
      child: Image.network(submission.preview[0].source.url.toString()),
    );
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
        DragoDivider(),
        Padding(
          padding: EdgeInsets.only(bottom: 6),
        ),
        _buttonRow(),
        Padding(
          padding: EdgeInsets.only(top: 6),
        ),
        DragoDivider()
      ],
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

  _Comment({
    @required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return (this.comment.depth == 0)
        ? _topLevelComment(context, this.comment)
        : _notTopLevelComment(context, this.comment);

    // return Padding(
    //     padding: EdgeInsets.only(left: this.comment.depth * 4.0),
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 8.0),
    //           child: DragoDivider(),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               border: Border(
    //                 left: BorderSide(
    //                     width: 4, color: CupertinoColors.destructiveRed),
    //               ),
    //             ),
    //             child: Padding(
    //               padding: EdgeInsets.only(left: 8.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   _topBar(context, this.comment),
    //                   _body(context, this.comment),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));
  }

  _topLevelComment(BuildContext context, comment) {
    return Column(
      children: <Widget>[
        DragoDivider(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _topBar(context, comment),
              _body(context, comment)
            ],
          ),
        )
      ],
    );
  }

  _notTopLevelComment(BuildContext context, comment) {
    return Padding(
        padding: EdgeInsets.only(left: this.comment.depth * 4.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: DragoDivider(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 4, color: CupertinoColors.destructiveRed),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _topBar(context, this.comment),
                      _body(context, this.comment),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _topBar(BuildContext context, Comment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            _author(context, comment),
            SubmissionScore(
              score: comment.score,
            )
          ],
        ),
        Row(
          children: <Widget>[
            _options(context, comment),
            SubmissionAge(
              createdUtc: comment.createdUtc,
            )
          ],
        )
      ],
    );
  }

  _body(BuildContext context, Comment comment) {
    return Text(
      comment.body,
      textAlign: TextAlign.start,
    );
  }

  //TODO refactor all of these into class widgets and put in 'common' folder
  _author(BuildContext context, Comment comment) {
    return Text(comment.author);
  }

  _options(BuildContext context, Comment comment) {
    return Icon(CupertinoIcons.ellipsis);
  }
}
