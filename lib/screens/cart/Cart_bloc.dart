
import 'dart:async';
import 'package:unigran_tcc/screens/cart/Cart.dart';
import 'package:unigran_tcc/screens/cart/Cart_api.dart';

class CartBlocc {
  final _streamController = StreamController<List<Cart>>();
  Stream<List<Cart>> get stream => _streamController.stream;

  Future<List<Cart>> fetch(context) async {
    try {

        List<Cart> dados = await CartApi.get(context);
        _streamController.add(dados);
        return dados;


    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Cart>> fetchEscola(context,int escola) async {
    try {
        List<Cart> dados = await CartApi.getEscola(context,escola);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  void dispose() {
    _streamController.close();

  }
}
