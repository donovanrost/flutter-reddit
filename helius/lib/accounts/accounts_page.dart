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
    return Center(child: Text('accountsPage'),);

   
  }
}
