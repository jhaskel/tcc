import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_api.dart';

class NivelBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<NivelEscolar>>();
  Stream<List<NivelEscolar>> get stream => _streamController.stream;
  List<NivelEscolar> _lista =[];
  int itens = 0;

  Future<List<NivelEscolar>> fetch(context) async {
   try {
        List<NivelEscolar> dados = await NivelEscolarApi.get(context);
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

  List<NivelEscolar> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<NivelEscolar>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(NivelEscolar item) {
    _lista.add(item);
    increase(item);
  }

  remove(NivelEscolar item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInNivelEscolar(NivelEscolar item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(NivelEscolar item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(NivelEscolar item) {
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
