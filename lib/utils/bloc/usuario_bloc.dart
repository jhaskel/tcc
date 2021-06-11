import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_api.dart';

class UsuarioBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Usuario>>();
  Stream<List<Usuario>> get stream => _streamController.stream;
  List<Usuario> _lista =[];
  int itens = 0;

  Future<List<Usuario>> fetch(context) async {
   print('aquixx');
   try {
        List<Usuario> dados = await UsuarioApi.get(context);
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

  Future<List<Usuario>> fetchId(context,int id) async {
  print('aqui');
    try {
        List<Usuario> dados = await UsuarioApi.getId(context,id);
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

  List<Usuario> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Usuario>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Usuario item) {
    _lista.add(item);
    increase(item);
  }

  remove(Usuario item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInUsuario(Usuario item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Usuario item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Usuario item) {
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
