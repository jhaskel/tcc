import 'dart:async';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_api.dart';

class PedidoItensBloc {
  final _streamController = StreamController<List<PedidoItens>>();
  Stream<List<PedidoItens>> get stream => _streamController.stream;


  Future<List<PedidoItens>> fetchAf(context, int af) async {
    try {

        List<PedidoItens> dados = await PedidoItensApi.getByAf(context, af);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchAfi(
    context,
  ) async {
    try {

        List<PedidoItens> dados = await PedidoItensApi.getByAfi(context);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchTotalMes(context, int ano) async {
    try {

        List<PedidoItens> dados =
            await PedidoItensApi.getByTotalMes(context, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalMesEscola(
      context, int escola, int ano) async {
    try {

        List<PedidoItens> dados =
            await PedidoItensApi.getByTotalMesEscola(context, escola, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchTotalCategoria(context, int ano) async {
    try {
        List<PedidoItens> dados =
            await PedidoItensApi.getByTotalCategoria(context, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchTotalCategoriaEscola(
      context, int escola, int ano) async {
    try {

        List<PedidoItens> dados =
            await PedidoItensApi.getByTotalCategoriaEscola(
                context, escola, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchTotalEscola(context, int ano) async {
    try {

        List<PedidoItens> dados =
            await PedidoItensApi.getByTotalEscola(context, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMediaAlunos(context, int ano) async {
    try {

        List<PedidoItens> dados =
            await PedidoItensApi.getByMediaAlunos(context, ano);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMaisPedidos(context, int ano) async {
    try {
        List<PedidoItens> dados =
            await PedidoItensApi.getMaisPedido(context, ano);
        _streamController.add(dados);
        return dados;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchPedidoAll(context, int pedido) async {
    try {
        List<PedidoItens> dados = await PedidoItensApi.getPed(context, pedido);
        _streamController.add(dados);
        return dados;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

   Future<List<PedidoItens>> fetchProduto(context, int produto) async {
    try {
        List<PedidoItens> dados = await PedidoItensApi.getProduto(context, produto);
        _streamController.add(dados);
        return dados;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

   Future<List<PedidoItens>> fetchProduto2(context, int produto) async {
    try {
        List<PedidoItens> dados = await PedidoItensApi.getProduto2(context, produto);
        _streamController.add(dados);
        return dados;
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
