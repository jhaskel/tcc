import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor_api.dart';


class FornecedorBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Fornecedor>>();
  Stream<List<Fornecedor>> get stream => _streamController.stream;
  List<Fornecedor> _lista =[];
  int itens = 0;

  Future<List<Fornecedor>> fetch(context) async {
   print('aquixx');
   try {
        List<Fornecedor> dados = await FornecedorApi.get(context);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Fornecedor>> fetchId(context,int id) async {
  print('aqui');
    try {
        List<Fornecedor> dados = await FornecedorApi.getId(context,id);
        _streamController.add(dados);
         _lista.clear();
        addAll(dados);
        return dados;
    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  List<Fornecedor> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Fornecedor>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Fornecedor item) {
    _lista.add(item);
    increase(item);
  }

  remove(Fornecedor item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInFornecedor(Fornecedor item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Fornecedor item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Fornecedor item) {
    itens = 0;
    _lista.forEach((x) {
      itens--;
    });
    notifyListeners();
  }

  calculateItens() {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
