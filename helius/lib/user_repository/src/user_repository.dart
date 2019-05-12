import 'dart:async';
import 'package:reddit/reddit.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserRepository {

  String _secret = '';
  String _identifier = 'Hp4M9q3bOeds3w';
  String _deviceID = 'pooppooppooppooppooppoop';
  var _client = http.Client();
  Reddit _reddit;

  UserRepository(){
     _reddit = Reddit(_client);

  }



  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    _reddit = Reddit(_client);

    _reddit.authSetup(_identifier, _secret);
    // await _reddit.authFinish();
    
    await _reddit.authFinish(
      username: username, 
      password: password, 
      clientType: 'installed_client', 
      deviceID: _deviceID,
      );

    return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}