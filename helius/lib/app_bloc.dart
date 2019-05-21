import 'package:flutter/foundation.dart';

class Bloc extends Object {

  final _repository;

  Bloc(this._repository) {
    _repository.init();
  }



  

  void dispose() {

  }
}