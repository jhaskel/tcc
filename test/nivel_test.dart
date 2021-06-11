import 'dart:js';

import 'package:test/test.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_page.dart';
import 'package:unigran_tcc/utils/bloc/nivel_bloc.dart';

void main() {
  group('Counter', () {
    test('value should be incremented', () {
       final lt = NivelBloc();
      lt.fetch(context);
      expect(lt.lista, 1);
    });
  });
}
