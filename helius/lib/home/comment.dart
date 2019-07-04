import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/common/common.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final unescape = new HtmlUnescape();

  CommentWidget({
    @required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return _slideable(
        context,
        (this.comment.depth == 0)
            ? _topLevelComment(context, this.comment)
            : _notTopLevelComment(context, this.comment));
  }

  Widget _slideable(BuildContext content, child) {
    // TODO https://pub.dev/packages/flutter_slidable#-readme-tab-
    // None of these actions do anything. This slidable
    // isn't of the same style as Apollo. I'm Just leaving
    // this here because I can't figure out how to do it properly

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: child,
      actions: <Widget>[
        IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () => null),
        IconSlideAction(
            caption: 'Share',
            color: Colors.indigo,
            icon: Icons.share,
            onTap: () => null),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'More',
            color: Colors.black45,
            icon: Icons.more_horiz,
            onTap: () => null),
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => null),
      ],
    );
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
            ),
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
    return MarkdownBody(
      data: unescape.convert(comment.body),
      onTapLink: (url) => _launchURL(url),
    );
    // return Text(
    //   comment.body,
    //   textAlign: TextAlign.start,
    // );
  }

  _launchURL(url) async {
    // const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //TODO refactor all of these into class widgets and put in 'common' folder
  _author(BuildContext context, Comment comment) {
    return Text(comment.author);
  }

  _options(BuildContext context, Comment comment) {
    return Icon(CupertinoIcons.ellipsis);
  }
}
