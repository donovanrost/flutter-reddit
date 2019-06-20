import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/classes/content_type.dart';
import 'package:helius/classes/image_model.dart';
import 'package:helius/classes/video_model.dart';
import 'package:helius/common/media_player.dart';
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
  final _scrollController = ScrollController();
  double positionBeforeScrollToTop = 0;

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
          onTap: () => scroll(),
          previousPageTitle: '', //TODO this needs to be passed in to this page
          middle: Text('${bloc.submission.numComments} comments'),
        ),
        child: SafeArea(child: _submissionPage(context)),
      ),
    );
  }

  Widget _buildContentWidget() {
    return StreamBuilder(
        stream: bloc.content,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Container(
              child: Text('error'),
            );
          } else {
            print('${snapshot.data} ---- ${snapshot.data.url}');

            if (snapshot.data is ImageModel) {
              // print('${snapshot.data} ---- ${snapshot.data.url}');
              return Container(child: Image.network(snapshot.data.url));
            }

            if (snapshot.data is VideoModel) {
              return MediaPlayer(
                url: snapshot.data.url,
              );
            }
            return Container(
              child: Text('Some other type of conent'),
            );
          }
        });
  }

  void scroll() {
    //50 is just a small arbitrary number. Maybe some other number is better
    if (_scrollController.position.pixels < 50) {
      _scrollController.animateTo(positionBeforeScrollToTop,
          curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    } else {
      positionBeforeScrollToTop = _scrollController.position.pixels;
      _scrollController.animateTo(0,
          curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    }
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
      child: Image.network(
        submission.preview[0].source.url.toString(),
        gaplessPlayback: true,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  Widget _submissionInfoArea(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _submissionTitle(context, this.bloc.submission),
          _infoAreaFirstRow(context, this.bloc.submission),
          _infoAreaSecondRow(context, this.bloc.submission),
          // SubmissionActionBar(),
        ],
      ),
    ));
  }

  Widget _submissionTitle(BuildContext context, Submission submission) {
    return Wrap(
      children: [
        Text(
          submission.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        if (submission.linkFlairText != null)
          FlairWidget(flairText: submission.linkFlairText)
      ],
    );
  }

  Widget _infoAreaFirstRow(BuildContext context, Submission submission) {
    return Wrap(
      children: <Widget>[
        Text(
          'in ${submission.subreddit.displayName} by ${submission.author}',
        ),
        if (submission.authorFlairText != null)
          FlairWidget(
            flairText: submission.authorFlairText,
          )
      ],
    );
  }

  Widget _infoAreaSecondRow(BuildContext context, Submission submission) {
    return Wrap(
      children: <Widget>[
        SubmissionScore(
          score: submission.score,
        ),
        SubmissionAge(
          createdUtc: submission.createdUtc,
        )
      ],
    );
  }

  Widget _submissionPage(BuildContext context) {
    List<Widget> _slivers = [];

    _slivers.add(SliverToBoxAdapter(child: _buildContentWidget()));
    // _slivers.add(_submissionImage(context, this.bloc.submission));
    _slivers.add(_submissionInfoArea(context));
    _slivers.add(SliverToBoxAdapter(child: SubmissionActionBar()));
    _slivers.add(_commentList(context));

    return CustomScrollView(controller: _scrollController, slivers: _slivers);
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
