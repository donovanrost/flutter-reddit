import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:helius/app_provider.dart';
import 'package:helius/home/routing_message.dart';
import 'package:helius/home/subreddit_list_item.dart';
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
  final BehaviorSubject subredditContent = BehaviorSubject();
  StreamSubscription _subscription;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _SubredditPageState(this.message) {
    _scrollController.addListener(_onScroll);
  }

  @override
  void initState() {
    // _SubredditPageState();
    print(_scrollController.toString());
    super.initState();
  }



  _fillStream({bloc})  {

    var s = bloc.test(message.subredditName.toLowerCase());
    s.then((data) {
      _subscription =  data.listen((d) {
        
        if(!subredditContent.hasValue) {
          subredditContent.add([d]);
        } else {
          List temp = subredditContent.value;
          temp.add(d);
          subredditContent.add(temp);
        }

      });

    });



  }

  @override
  Widget build(BuildContext context) {
    bloc = AppProvider.of(context);
    _fillStream(bloc: bloc );





    return SafeArea(
      top: false,
      child: CupertinoPageScaffold(child: _subredditPage(context)),
    );
  }

  Widget _list(BuildContext context) {
    var unescape = new HtmlUnescape();

    return StreamBuilder(
        stream: subredditContent,
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
            print('redbuilding.... ${snapshot.data.length}');
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => SubredditListItem(
                      item: snapshot.data[i],
                      lastItem: i == snapshot.data.length - 1),
                  childCount: snapshot.data.length),
            );
          }
        });
  }

  Widget _subredditPageNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      automaticallyImplyLeading: false,
      automaticallyImplyTitle: false,
      largeTitle:  Text(message.subredditName),
      leading: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: () => Navigator.of(context).pop(), //TODO
      ),
      // middle: Text(subredditName),
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

    return CustomScrollView(
      controller: _scrollController,
      slivers: _slivers);
  }

  @override
  void dispose() {
    _subscription.pause();

    subredditContent.drain();
    subredditContent.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
        print(currentScroll.toString());
      // _fillStream(bloc: bloc, whichBatch: 'initial' );
    }
  }
}
