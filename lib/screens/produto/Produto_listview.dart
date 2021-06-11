import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/screens/produto/Produto_api.dart';
import 'package:unigran_tcc/screens/produto/Produto_detalhe.dart';
import 'package:unigran_tcc/screens/produto/Produto_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class ProdutoListView extends StatefulWidget {
  final List<Produto> produto;
  ProdutoListView(this.produto);

  @override
  _ProdutoListViewState createState() => _ProdutoListViewState();
}

class _ProdutoListViewState extends State<ProdutoListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Produto> produto2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {
    return _grid(widget.produto);
  }

  _grid(List<Produto> produto) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.produto.length,
              itemBuilder: (context, index) {
                Produto c = widget.produto[index];

                return _cardProduto(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardProduto(Produto c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
        onTap: ()=>_onClickDetalhe(c),
          leading: CircleAvatar(
            backgroundColor: c.isativo ? AppColors.secundaria : AppColors.grey,
            child: Text(i.toString()),
          ),
          title: c.isativo
              ? Text(c.alias)
              : Text(
                  c.alias,
                  style: AppTextStyles.body_noAtive,
                ),

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
        Divider(
        thickness: 1.2,
          color: c.agrofamiliar ? Colors.green : Colors.grey,
        )
      ],
    );
  }

  showExcluir(
    BuildContext context,
    Produto dados,
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
          widget.produto.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.alias} '),
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

  Future<void> _onClickExcuir(Produto dados) async {
    var dado = dados ?? Produto();
    dado.id = dados.id;
    await ProdutoApi.delete(context, dado);
  }



  void _onClickEdit(Produto c) {
    push(
        context,
        ProdutoEdit(
          produto: c,
        ));
  }

  void _onClickDetalhe(Produto c) {
    push(
        context,
        ProdutoDetalhe(
          produto: c,
        ));
  }
}
