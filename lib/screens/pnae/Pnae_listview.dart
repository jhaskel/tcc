import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/pnae/Pnae.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_api.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:intl/intl.dart';

class PnaeListView extends StatefulWidget {
  final List<Pnae> pnae;
  PnaeListView(this.pnae);

  @override
  _PnaeListViewState createState() => _PnaeListViewState();
}

class _PnaeListViewState extends State<PnaeListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Pnae> pnae2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  var formatador = NumberFormat("#,##0.00", "pt_BR");

  @override
  Widget build(BuildContext context) {
    return _grid(widget.pnae);
  }

  _grid(List<Pnae> pnae) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.pnae.length,
              itemBuilder: (context, index) {
                Pnae c = widget.pnae[index];

                return _cardPnae(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardPnae(Pnae c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: c.isativo ? AppColors.secundaria : AppColors.grey,
            child: Text(i.toString()),
          ),
          title: c.isativo
              ? Text('R\$  ${formatador.format(c.valor)}')
              : Text(
                  'R\$  ${formatador.format(c.valor)}',
                  style: AppTextStyles.body_noAtive,
                ),
          subtitle: Text(c.ano.toString()),
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
    Pnae dados,
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
          widget.pnae.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.valor} '),
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

  Future<void> _onClickExcuir(Pnae dados) async {
    var dado = dados ?? Pnae();
    dado.id = dados.id;
    await PnaeApi.delete(context, dado);
  }



  void _onClickEdit(Pnae c) {
    push(
        context,
        PnaeEdit(
          pnae: c,
        ));
  }
}
