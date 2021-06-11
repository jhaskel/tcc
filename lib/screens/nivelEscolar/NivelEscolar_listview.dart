import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_api.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class NivelEscolarListView extends StatefulWidget {
  final List<NivelEscolar> nivelEscolar;
  NivelEscolarListView(this.nivelEscolar);

  @override
  _NivelEscolarListViewState createState() => _NivelEscolarListViewState();
}

class _NivelEscolarListViewState extends State<NivelEscolarListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<NivelEscolar> nivelEscolar2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {
    return _grid(widget.nivelEscolar);
  }

  _grid(List<NivelEscolar> nivelEscolar) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.nivelEscolar.length,
              itemBuilder: (context, index) {
                NivelEscolar c = widget.nivelEscolar[index];
                return _cardNivelEscolar(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardNivelEscolar(NivelEscolar c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
    children: [
    ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.secundaria,
          child: Text(i.toString()),
        ),
        title: Text(c.nome),
        subtitle: Text(c.isativo.toString()),
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
    NivelEscolar dados,
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
          widget.nivelEscolar.removeWhere((element) => element.id == dados.id);
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

  Future<void> _onClickExcuir(NivelEscolar dados) async {
    var dado = dados ?? NivelEscolar();
    dado.id = dados.id;
    await NivelEscolarApi.delete(context, dado);
  }



  void _onClickEdit(NivelEscolar c) {
    push(
        context,
        NivelEscolarEdit(
          nivelEscolar: c,
        ));
  }
}
