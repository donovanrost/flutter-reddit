import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/common.dart';
import 'package:helius/home/submission_provider.dart';
import './comment.dart';

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
          previousPageTitle: bloc.submission.subreddit.displayName,
          middle: Text('${bloc.submission.numComments} comments'),
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
          (m) => (m is Comment)
              ? CommentWidget(comment: m)
              : Text('More Comments'),
        )
        .toList();
  }

  //TODO THIS IS NOT RIGHT, BUT JUST A PLACEHOLDER
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
