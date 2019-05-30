import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:helius/app_provider.dart';
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
  // final RoutingMessage message;
  var bloc;
  var rebuildCounter = 0;

  // final _scrollController = ScrollController();
  // final _scrollThreshold = 200.0;

  _SubredditPageState(/*this.message*/) {
    // _scrollController.addListener(_onScroll);
  }

  @override
  void initState() {
    // _SubredditPageState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = SubmissionProvider.of(context);
    // bloc.loadHotFor(subreddit: message.subredditName);
    // _fillStream(bloc: bloc);

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
      trailing: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Text("Edit"),
        onPressed: () {}, //TODO
      ),
    );
  }

  Widget _submissionPage(BuildContext context) {
    List<Widget> _slivers = [];

    _slivers.add(_submissionPageNavigationBar(context));
    // _slivers.add(_list(context));

    return CustomScrollView(
        // controller: _scrollController,
        slivers: _slivers);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  // void _onScroll() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   if (maxScroll - currentScroll <= _scrollThreshold) {
  //     print(currentScroll.toString());
  //     bloc.resumeStream();
  //   }
  // }
}
