import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class UnidadeEscolarDetalhe extends StatefulWidget {
  final UnidadeEscolar unidade;
  UnidadeEscolarDetalhe({this.unidade});

  @override
  _UnidadeEscolarDetalheState createState() => _UnidadeEscolarDetalheState();
}

class _UnidadeEscolarDetalheState extends State<UnidadeEscolarDetalhe> {
  UnidadeEscolar get dados => widget.unidade;
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
          UnidadeEscolarEdit(
            unidadeEscolar: dados,
          ));
    });
  }
}
