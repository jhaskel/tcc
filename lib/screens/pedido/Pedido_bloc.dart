import 'dart:async';
import 'package:unigran_tcc/screens/pedido/Pedido.dart';
import 'package:unigran_tcc/screens/pedido/Pedido_api.dart';

class PedidoBloc {
  final _streamController = StreamController<List<Pedido>>();
  Stream<List<Pedido>> get stream => _streamController.stream;

  Future<List<Pedido>> fetch(context) async {
    try {
        List<Pedido> dados = await PedidoApi.get(context);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Pedido>> fetchEscola(context,int escola) async {
    try {
        List<Pedido> dados = await PedidoApi.getEscola(context,escola);
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
