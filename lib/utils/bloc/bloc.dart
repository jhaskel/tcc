import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BlocController extends BlocBase {

  BlocController();

//Stream that receives a number and changes the count;
  var _counterController = BehaviorSubject<String>.seeded('home');
  var _textAppBar = BehaviorSubject<String>.seeded('Merenda Escolar');
//output
  Stream<String> get outPage => _counterController.stream;
  Stream<String> get outTextAppBar => _textAppBar.stream;
//input
  Sink<String> get inPage => _counterController.sink;
  Sink<String> get inTextAppBar => _textAppBar.sink;


//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterController.close();
    _textAppBar.close();
    super.dispose();
  }

}