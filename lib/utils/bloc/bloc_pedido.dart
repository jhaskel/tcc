import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unigran_tcc/screens/pedido/Pedido.dart';

class BlocPedido extends BlocBase {
  BlocPedido();
  List<Pedido> lista;

//Stream that receives a number and changes the count;

  var _counterController = BehaviorSubject<List<Pedido>>.seeded([]);
  var _quant = BehaviorSubject<int>.seeded(0);
  var _quant2 = BehaviorSubject<int>.seeded(-1);

//output
  Stream<List<Pedido>> get outPage => _counterController.stream;
  Stream<int> get outQuant => _quant.stream;
//input
  Sink<List<Pedido>> get inPage => _counterController.sink;
  Sink<int> get inQuant => _quant.sink;

  decrementar(){
    _quant.add(_quant.value -1);
  }
//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterController.close();
    _quant.close();
    super.dispose();
  }
}
