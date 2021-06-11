import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_api.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class UnidadeEscolarListView extends StatefulWidget {
  final List<UnidadeEscolar> unidadeEscolar;
  UnidadeEscolarListView(this.unidadeEscolar);

  @override
  _UnidadeEscolarListViewState createState() => _UnidadeEscolarListViewState();
}

class _UnidadeEscolarListViewState extends State<UnidadeEscolarListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  List<UnidadeEscolar> unidadeEscolar2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {
    return _grid(widget.unidadeEscolar);
  }

  _grid(List<UnidadeEscolar> unidadeEscolar) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.unidadeEscolar.length,
              itemBuilder: (context, index) {
                UnidadeEscolar c = widget.unidadeEscolar[index];
                return _cardUnidadeEscolar(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardUnidadeEscolar(UnidadeEscolar c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
    children: [
    ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.secundaria,
          child: Text(i.toString()),
        ),
        title: Text(c.nome),
        subtitle: Text('${c.alunos} alunos'),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      pop(context);
                      _onClickEdit(c);
                    },
                    child: Text("Editar")),
              ),
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      pop(context);
                      showExcluir(context, c);
                    },
                    child: Text("Excluir")),
              ),
            ),
          ],
        ),

      ),
      Divider(thickness: 1,)
    ],

    );
  }

  showExcluir(
    BuildContext context,
    UnidadeEscolar dados,
  ) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          widget.unidadeEscolar
              .removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.nome} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse registro?'),
            ),
          ],
        ),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _onClickExcuir(UnidadeEscolar dados) async {
    var dado = dados ?? UnidadeEscolar();
    dado.id = dados.id;
    await UnidadeEscolarApi.delete(context, dado);
  }



  void _onClickEdit(UnidadeEscolar c) {
    push(
        context,
        UnidadeEscolarEdit(
          unidadeEscolar: c,
        ));
  }
}
