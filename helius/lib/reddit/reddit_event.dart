import 'package:equatable/equatable.dart';

abstract class RedditEvent extends Equatable {
  RedditEvent([List props = const []]) : super(props);
}

class InitializeReddit extends RedditEvent {
  @override
  String toString() => 'AppStarted';
}

class RedditUnitialized extends RedditEvent {

  RedditUnitialized() : super([]);

  @override
  String toString() => 'RedditUnitialized';
}

class RedditBeganInitialization extends RedditEvent {
  @override
  String toString() => 'RedditBeganInitialization';
}

class RedditInitialized extends RedditEvent {
  @override
  String toString() => 'RedditInitialized';
}