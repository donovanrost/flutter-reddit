import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:helius/app_provider.dart';
import 'package:helius/home/routing_message.dart';
import 'package:helius/home/submission_page.dart';
import 'package:helius/home/submission_provider.dart';
import 'package:helius/home/subreddit_list_item.dart';
import 'package:helius/home/subreddit_provider.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:rxdart/subjects.dart';
import 'package:helius/common/loading_indicator.dart';

class SubredditPage extends StatefulWidget {
  RoutingMessage message;

  SubredditPage({@required this.message});
  @override
  _SubredditPageState createState() => _SubredditPageState(message);
}

class _SubredditPageState extends State<SubredditPage> {
  final RoutingMessage message;
  var bloc;
  var rebuildCounter = 0;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _SubredditPageState(this.message) {
    _scrollController.addListener(_onScroll);
  }

  @override
  void initState() {
    // _SubredditPageState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bloc = AppProvider.of(context);
    bloc = SubredditProvider.of(context);
    bloc.loadHotFor(subreddit: message.subredditName);
    // _fillStream(bloc: bloc);

    return SafeArea(
      top: false,
      child: CupertinoPageScaffold(
          // child: Center(child: Text('asd'))
          child: _subredditPage(context)),
    );
  }

  Widget _list(BuildContext context) {
    var unescape = new HtmlUnescape();

    return StreamBuilder(
        stream: bloc.subredditContent,
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
            print('redbuilding.... ${rebuildCounter++}');
            bloc.pauseStream();
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  SubmissionProvider(child: SubmissionPage()))),
                      child: SubredditListItem(
                          item: snapshot.data[i],
                          bloc: bloc,
                          lastItem: i == snapshot.data.length - 1)),
                  childCount: snapshot.data.length),
            );
          }
        });
  }

  Widget _subredditPageNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      key: GlobalKey(),
      largeTitle: Text(message.subredditName),
      previousPageTitle: message.previousPage,
      trailing: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Text("Edit"),
        onPressed: () {}, //TODO
      ),
    );
  }

  Widget _subredditPage(BuildContext context) {
    List<Widget> _slivers = [];

    _slivers.add(_subredditPageNavigationBar(context));
    _slivers.add(_list(context));

    return CustomScrollView(controller: _scrollController, slivers: _slivers);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print(currentScroll.toString());
      bloc.resumeStream();
    }
  }
}
