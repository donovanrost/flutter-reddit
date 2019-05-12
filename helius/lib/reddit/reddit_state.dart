import 'package:equatable/equatable.dart';

abstract class RedditState extends Equatable {}

class RedditIsUninitialized extends RedditState {
  @override
  String toString() => 'RedditUninitialized';
}

class RedditIsInitializing extends RedditState {
  @override
  String toString() => 'RedditInitializing';
}

class RedditIsInitialized extends RedditState {
  @override
  String toString() => 'RedditInitialized';
}