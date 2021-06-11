import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/categoria/categoria_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class CategoriaDetalhe extends StatefulWidget {
  final Categoria nivel;
  CategoriaDetalhe({this.nivel});

  @override
  _CategoriaDetalheState createState() => _CategoriaDetalheState();
}

class _CategoriaDetalheState extends State<CategoriaDetalhe> {

  Categoria get dados =>widget.nivel;
  bool _showProgress = false;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();


  @override
  Widget build(BuildContext context) {
    return !_showProgress ?Scaffold(
      appBar: AppBar(title: Text('Detalhe'),

      ),
      body: _body(),

    ):CircularProgressIndicator();
  }

  _body() {
    return Center(child: Text(dados.nome));
  }

  _onClickAdd() {
    setState(() {
      push(context, CategoriaEdit(categoria: dados,));
    });
  }


}
