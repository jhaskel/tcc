import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/categoria/categoria_api.dart';



class CategoriaBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Categoria>>();
  Stream<List<Categoria>> get stream => _streamController.stream;
  List<Categoria> _lista =[];
  int itens = 0;

  Future<List<Categoria>>fetch(context) async {
   try {
        List<Categoria> dados = await CategoriaApi.get(context);
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

    Future<List<Categoria>> fetchId(context,int id) async {
   try {
        List<Categoria> dados = await CategoriaApi.getId(context,id);
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

  List<Categoria> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Categoria>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Categoria item) {
    _lista.add(item);
    increase(item);
  }

  remove(Categoria item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInCategoria(Categoria item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Categoria item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Categoria item) {
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
