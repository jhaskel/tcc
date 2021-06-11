import 'dart:async';
import 'package:unigran_tcc/screens/af/Af.dart';
import 'package:unigran_tcc/screens/af/af_api.dart';

class AfBloc {
  final _streamController = StreamController<List<Af>>();
  Stream<List<Af>> get stream => _streamController.stream;

  // ignore: missing_return
  Future<List<Af>> fetch(context) async {
    try {
      List<Af> afs = await AfApi.get(context);
      _streamController.add(afs);
      return afs;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  // ignore: missing_return


  // ignore: missing_return
  Future<List<Af>> fetchFornecedor(context, int fornecedor) async {
    try {
      List<Af> afs = await AfApi.getFornecedor(context, fornecedor);
      _streamController.add(afs);
      return afs;
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
