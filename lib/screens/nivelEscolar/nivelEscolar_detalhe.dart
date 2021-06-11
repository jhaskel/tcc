import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class NivelEscolarDetalhe extends StatefulWidget {
  final NivelEscolar nivel;
  NivelEscolarDetalhe({this.nivel});

  @override
  _NivelEscolarDetalheState createState() => _NivelEscolarDetalheState();
}

class _NivelEscolarDetalheState extends State<NivelEscolarDetalhe> {
  NivelEscolar get dados => widget.nivel;
  bool _showProgress = false;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {
    return !_showProgress
        ? Scaffold(
            appBar: AppBar(
              title: Text('Detalhe'),
            ),
            body: _body(),
          )
        : CircularProgressIndicator();
  }

  _body() {
    return Center(child: Text(dados.nome));
  }

  _onClickAdd() {
    setState(() {
      push(
          context,
          NivelEscolarEdit(
            nivelEscolar: dados,
          ));
    });
  }
}
