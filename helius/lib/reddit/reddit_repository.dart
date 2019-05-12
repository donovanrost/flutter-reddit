import 'dart:async';
import 'package:reddit/reddit.dart';
import 'package:meta/meta.dart';


class RedditRepository {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop';
  var client;
  Reddit reddit;

  
  RedditRepository({@required this.reddit}) {

  }
    
  
 Future<Null> init() async {
    reddit.authSetup(_identifier, _secret);
    await reddit.authFinish(
      // username: username, 
      // password: password, 
      clientType: 'installed_client', 
      deviceID: _deviceID,
    );
    reddit.frontPage.hot().limit(10).fetch().then(print);
    return Future<Null>.value(null);
  }  
}




