import 'package:rxdart/rxdart.dart';
class Bloc extends Object {

  final _repository;

  Stream get mySubscriptions => _repository.reddit.mySubscriptions;
  BehaviorSubject get reddit => _repository.reddit.redditInstance;

  Bloc(this._repository) {
    _repository.reddit.init();
  }



  

  void dispose() {

  }
}