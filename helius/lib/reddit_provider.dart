import 'dart:io';
import 'dart:async';
import 'package:draw/draw.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedditProvider {
  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop';
  Reddit _reddit;
  String _state = 'thisisarandomstring';
  Reddit get reddit => _reddit;
  BehaviorSubject<Reddit> instance = BehaviorSubject<Reddit>();
  Stream get mySubscriptions => _reddit.user.subreddits();

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

  RedditProvider();

  // Future<Null> _freshInit() async {
  //   Stream<String> onCode = await _server();

  //   _reddit = Reddit.createWebFlowInstance(
  //     userAgent: userAgent,
  //     clientId: _identifier,
  //     clientSecret: _secret,
  //     redirectUri: Uri.parse('http://localhost:8080'),
  //   );

  //   final authUrl =
  //       _reddit.auth.url(_scopes, _state, compactLogin: true).toString();
  //   print(authUrl);

  //   final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
  //   webviewPlugin.launch(authUrl, clearCache: true, clearCookies: true);

  //   final String code = await onCode.first;
  //   await _reddit.auth.authorize(code);

  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setString(
  //       'reddit_auth_token', _reddit.auth.credentials.toJson());

  //   print("CODE IS $code");
  //   print(await _reddit.user.me());

  //   webviewPlugin.close();

  //   return Future<Null>.value(null);
  // }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('reddit_auth_token');

    if (token == null) {
      final reddit = await Reddit.createUntrustedReadOnlyInstance(
          userAgent: userAgent,
          clientId: _identifier,
          deviceId: _deviceID,
      );
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

  // Future<Null> init() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String token = prefs.getString('reddit_auth_token');
  // print(token);
  // if (token == null) {
  //   return _freshInit();
  // } else {
  //   _reddit = await Reddit.restoreAuthenticatedInstance(
  //     token,
  //     userAgent: userAgent,
  //     redirectUri: Uri.parse('http://localhost:8080'),
  //     clientId: _identifier,
  //     clientSecret: _secret,
  //   );

  //   return Future<Null>.value(null);
  // }
  // }

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

  // Future<Null> fetchMySubscriptions() async {
  //   Stream x = reddit.user.subreddits();
  //   x.forEach((x) => print(x.displayName));

  //   return Future<Null>.value(null);
  // }
}
