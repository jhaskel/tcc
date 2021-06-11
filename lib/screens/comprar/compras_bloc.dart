import 'dart:async';
import 'package:unigran_tcc/screens/comprar/Compras.dart';
import 'package:unigran_tcc/screens/comprar/Compras_api.dart';
import 'package:unigran_tcc/utils/network.dart';

class ComprasBloc {
  final _streamController = StreamController<List<Compras>>();
  Stream<List<Compras>> get stream => _streamController.stream;

  Future<List<Compras>> fetch(context, String pedido) async {
    try {
      List<Compras> dicas = await ComprasApi.getByCart(context, pedido);
      _streamController.add(dicas);
      return dicas;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Compras>> fetchPedidoAll(context, int pedido) async {
    try {
      List<Compras> dicas = await ComprasApi.getPed(context, pedido);
      _streamController.add(dicas);
      return dicas;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}
