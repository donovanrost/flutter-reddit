
import './reddit_provider.dart';

class AppRepository {
  RedditProvider _reddit;

  Function get init => _reddit.init;

  AppRepository(){
    _reddit = RedditProvider();
  }








}