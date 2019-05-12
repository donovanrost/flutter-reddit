import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:helius/reddit/reddit_repository.dart';
import 'package:reddit/reddit.dart';
import 'package:http/http.dart' as http;

import 'reddit_event.dart';
import 'reddit_state.dart';


class RedditBloc extends Bloc<RedditEvent, RedditState> {

  // final _reddit = Reddit(http.Client());
  final _redditRepository = RedditRepository(reddit: Reddit(http.Client()));

 
  @override
  RedditState get initialState => RedditIsUninitialized();

  @override
  Stream<RedditState> mapEventToState(
    RedditEvent event,
  ) async* {
    if (event is RedditUnitialized) {
        yield RedditIsUninitialized();
    }
    if(event is RedditBeganInitialization) {
      yield  RedditIsInitializing();

    }
    if (event is RedditInitialized) {
      yield RedditIsInitialized();
    }
    if (event is InitializeReddit) {
      yield RedditIsInitializing();
      try {
        await _redditRepository.init();
        yield RedditIsInitialized();
      } catch (_) {
        print('Error in RedditBloc');
        // yield WeatherError();
      }
    }
    
  }
}