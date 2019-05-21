import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/home/subreddit_tile_model.dart';
import 'product_row_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class HomePage extends StatelessWidget {
  List subredditTiles = [
    SubredditTile(
        icon: CupertinoIcons.home,
        iconColor: CupertinoColors.destructiveRed,
        subreddit: 'home',
        subtitle: 'Posts from subscriptions',
        title: 'Home'),
    SubredditTile(
        icon: CupertinoIcons.add,
        iconColor: CupertinoColors.activeBlue,
        subreddit: 'home',
        subtitle: 'Most popular posts across Reddit',
        title: 'Popular Posts'),
    SubredditTile(
        icon: CupertinoIcons.add,
        iconColor: CupertinoColors.activeGreen,
        subreddit: 'home',
        subtitle: 'Posts across all subreddits',
        title: 'All Posts'),
    SubredditTile(
        icon: CupertinoIcons.add,
        iconColor: CupertinoColors.lightBackgroundGray,
        subreddit: 'home',
        subtitle: 'Posts from moderated subreddits',
        title: 'Moderator Posts')
  ];

  HomePage(context) {}

  //     var answer = await  _reddit.reddit.user.contributorSubreddits();
  // print(answer.toString());

  @override
  Widget build(BuildContext context) {
    return _homePageTab(context);
  }

  Widget _textInput() {
    return CupertinoTextField(
      autofocus: false,
      placeholder: "Search",
      prefix: Icon(CupertinoIcons.search),
      suffix: AnimatedContainer(
        duration: Duration(milliseconds: 5000),
        child: CupertinoButton(
          child: Text('Cancel'),
          onPressed: () {}, //TODO
        ),
      ),
      suffixMode: OverlayVisibilityMode.editing,
    );
  }

  Widget _homePageNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      automaticallyImplyLeading: false,
      automaticallyImplyTitle: false,
      largeTitle: _textInput(),
      leading: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: () {}, //TODO
      ),
      middle: Text('Home'),
      trailing: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Text("Edit"),
        onPressed: () {}, //TODO
      ),
    );
  }

  Widget _topListView(BuildContext context) {
    return SliverSafeArea(
      // BEGINNING OF NEW CONTENT
      top: false,
      minimum: const EdgeInsets.only(top: 0, bottom: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < subredditTiles.length) {
              return Material(
                  child: InkWell(
                onTap: () {
                  print('$index');
                },
                child: SubredditTileItem(
                  index: index,
                  subredditTile: subredditTiles[index],
                  lastItem: index == subredditTiles.length - 1,
                ),
              ));
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _header(context, state, index) {
    return Container(
      height: 20.0,
      color: (state.isPinned
              ? CupertinoColors.activeBlue
              : CupertinoColors.darkBackgroundGray)
          .withOpacity(1.0 - state.scrollPercentage),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        'Header #$index',
        style: const TextStyle(color: CupertinoColors.lightBackgroundGray),
      ),
    );
  }

  List<Widget> _headerBuilder(BuildContext context, int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      return new SliverStickyHeaderBuilder(
        builder: (context, state) => _header(context, state, sliverIndex),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => Container(child: Text('$i')),
            childCount: 8,
          ),
        ),
      );
    });
  }

  /* ======= PAGES ======= */

  Widget _homePageTab(BuildContext context) {
    List<Widget> _slivers = [];
    _slivers.add(_homePageNavigationBar(context));
    _slivers.add(_topListView(context));
    _slivers.addAll(_headerBuilder(context, 1, 15));

    return CustomScrollView(slivers: _slivers);
  }
}
