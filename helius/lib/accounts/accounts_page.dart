import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/app_bloc.dart';
import 'package:helius/app_provider.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({
    Key key,
  }) : super(key: key);

  @override
  State<AccountsPage> createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  Bloc bloc;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = AppProvider.of(context);
    return StreamBuilder(
      stream: bloc.reddit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage(context);
        } else if (!snapshot.hasData) {
          return _loadingPage(context);
        } else {
          return (snapshot.data.readOnly)
            ? _readOnlyPage(context, bloc)
            : _authenticatedPage(context);
        }
      },
    );
  }

  Widget _readOnlyPage(BuildContext context, bloc) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.add),
          onPressed: () => bloc.loginWithNewAccount,
        ),
        middle: Text('')
        
      ),
      child: Center(child: Text('Sign in to Reddit'))
    );
  }
  Widget _authenticatedPage(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.add),
          onPressed: () => bloc.loginWithNewAccount,
        ),
        middle: Text('')
        
      ),
      child: Center(child: Text('You are signed int'))
    );
  }

  Widget _loadingPage(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Widget _errorPage(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(child: Text('Hmmm... something went wrong')));
  }

  // Widget _buildPage(BuildContext context, bloc) {
  //   List<Widget> _slivers = [];
  //   _slivers.add(_accountsPageNavigationBar(context, bloc));

  //   return CustomScrollView(slivers: _slivers);
  // }

}
// return CupertinoSliverNavigationBar(
//       automaticallyImplyLeading: false,
//       automaticallyImplyTitle: false,
//       leading: CupertinoButton(
//         padding: EdgeInsets.all(0),
//         child: Icon(CupertinoIcons.add),
//         onPressed: () {}, //TODO
//       ),
//       middle: Text('Home'),

//     );
