import 'dart:io';
import 'dart:async';
import 'package:draw/draw.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedditProvider {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop';
  Reddit _reddit;
  String _state = 'thisisarandomstring';
  // Reddit get reddit => _reddit;
  BehaviorSubject<Reddit> instance = BehaviorSubject<Reddit>();
  BehaviorSubject mySubscriptions = BehaviorSubject();
  BehaviorSubject moderatorSubreddits = BehaviorSubject();

  List<String> _scopes = [
    'identity',
    'edit',
    'flair',
    'history',
    'modconfig',
    'modflair',
    'modlog',
    'modposts',
    'modwiki',
    'mysubreddits',
    'privatemessages',
    'read',
    'report',
    'save',
    'submit',
    'subscribe',
    'vote'
  ];
  final userAgent = 'ios:com.example.helios:v0.0.0 (by /u/pinkywrinkle)';

  RedditProvider() {
    instance.listen((data) {
      _subscriptionsListener(data);
      _moderationsListener(data);
    });
  }

  _moderationsListener(Reddit _reddit) {
    if(_reddit == null) {
      moderatorSubreddits.drain();
    } else  if (!_reddit.readOnly) {
      var subs = _reddit.user.moderatorSubreddits().toList();
      subs.then((data) {
        data.sort((a, b) => a.displayName.compareTo(b.displayName));
        moderatorSubreddits.add(data);
      });
    } else {
      moderatorSubreddits.add([]);
    }
  }

  _subscriptionsListener(Reddit _reddit) {
    if(_reddit == null) {
      mySubscriptions.drain();
    } else  if (_reddit.readOnly == false) {
      var subs = _reddit.user.subreddits(limit: 5000).toList();
      subs.then((data) {
        data.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
        
        // data.forEach((f) => print(f.displayName));

        mySubscriptions.add(data);
      });
    } else {
      mySubscriptions.add([]);
    }

  }

  loginWithNewAccount() async {
    /* //TODO
     Currently this allows the user to log in with one account. 
     Apollo is somehow able to maintain credentials for multiple accounts
     */

    Stream<String> onCode = await _server();

    _reddit = Reddit.createWebFlowInstance(
      userAgent: userAgent,
      clientId: _identifier,
      clientSecret: _secret,
      redirectUri: Uri.parse('http://localhost:8080'),
    );

    final authUrl =
        _reddit.auth.url(_scopes, _state, compactLogin: true).toString();
    print(authUrl);
    _launchURL(authUrl);

    final String code = await onCode.first;
    await _reddit.auth.authorize(code);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'reddit_auth_token', _reddit.auth.credentials.toJson());
    instance.add(_reddit);
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('reddit_auth_token');

    if (token == null) {
      final reddit = await Reddit.createUntrustedReadOnlyInstance(
        userAgent: userAgent,
        clientId: _identifier,
        deviceId: _deviceID,
      );
      print(reddit.readOnly.toString());

      instance.add(reddit);
    } else {
      final reddit = await Reddit.restoreAuthenticatedInstance(
        token,
        userAgent: userAgent,
        redirectUri: Uri.parse('http://localhost:8080'),
        clientId: _identifier,
        clientSecret: _secret,
      );
      instance.add(reddit);
    }
  }

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();

    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];

      print(code.toString());

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
        ..write("<html><h1>You can now close this window</h1></html>");

      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });

    return onCode.stream;
  }

  _launchURL(url) async {
    // const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
