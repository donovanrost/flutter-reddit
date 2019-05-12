import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helius/reddit/reddit.dart';

class HomePage extends StatelessWidget {
  RedditBloc _reddit;

  HomePage(context) {
    _reddit = BlocProvider.of<RedditBloc>(context);

    
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Text('asd')
      ),
    );
  }
}