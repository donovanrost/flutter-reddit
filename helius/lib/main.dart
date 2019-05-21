import 'package:flutter/cupertino.dart';
import 'package:helius/app_bloc.dart';
import 'package:helius/app_provider.dart';

import 'splash/splash.dart';
import 'home/home.dart';
import 'inbox/inbox.dart';
import 'common/common.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  App({
    Key key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(child: BottomTabBar());
  }
}

/* --------------------------------------- */

class BottomTabBar extends StatefulWidget {
  BottomTabBar({
    Key key,
  }) : super(key: key);

  @override
  State<BottomTabBar> createState() => BottomTabBarState();
}

class BottomTabBarState extends State<BottomTabBar> {
  Bloc bloc;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = AppProvider.of(context);

    return CupertinoApp(
        title: 'Helius',
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                title: Text('Post'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                title: Text('Inbox'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.shopping_cart),
                title: Text('Useranem'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.shopping_cart),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.shopping_cart),
                title: Text('Settings'),
              ),
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: HomePage(context),
                  );
                });
              case 1:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: InboxPage(),
                  );
                });
              case 2:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: InboxPage(),
                  );
                });
              case 3:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: InboxPage(),
                  );
                });
              case 4:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: InboxPage(),
                  );
                });
            }
          },
        ));
  }
}
