import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class FornecedorDetalhe extends StatefulWidget {
  Fornecedor nivel;
  FornecedorDetalhe({this.nivel});

  @override
  _FornecedorDetalheState createState() => _FornecedorDetalheState();
}

class _FornecedorDetalheState extends State<FornecedorDetalhe> {
  Fornecedor get dados => widget.nivel;
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
          FornecedorEdit(
            fornecedor: dados,
          ));
    });
  }
}
