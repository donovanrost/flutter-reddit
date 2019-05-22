import 'package:rxdart/rxdart.dart';
class Bloc extends Object {

  final _repository;

  Stream get mySubscriptions => _repository.reddit.mySubscriptions;
  BehaviorSubject get reddit => _repository.reddit.instance;
  Function get loginWithNewAccount => _repository.reddit.loginWithNewAccount();

  Bloc(this._repository) {
    _repository.reddit.init();
  }



  

  void dispose() {

  }
}