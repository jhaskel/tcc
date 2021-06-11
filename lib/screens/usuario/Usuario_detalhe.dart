import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class UsuarioDetalhe extends StatefulWidget {
  final Usuario nivel;
  UsuarioDetalhe({this.nivel});

  @override
  _UsuarioDetalheState createState() => _UsuarioDetalheState();
}

class _UsuarioDetalheState extends State<UsuarioDetalhe> {
  Usuario get dados => widget.nivel;
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
          UsuarioEdit(
            usuario: dados,
          ));
    });
  }
}
