import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/categoria/categoria_api.dart';
import 'package:unigran_tcc/screens/categoria/categoria_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class CategoriaListView extends StatefulWidget {
  final List<Categoria> categoria;
  CategoriaListView(this.categoria);

  @override
  _CategoriaListViewState createState() => _CategoriaListViewState();
}

class _CategoriaListViewState extends State<CategoriaListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Categoria> categoria2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {

    return _grid(widget.categoria);
  }

  _grid(List<Categoria> categoria) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.categoria.length,
              itemBuilder: (context, index) {
                Categoria c = widget.categoria[index];
                return _cardCategoria(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardCategoria(Categoria c, BoxConstraints constraints, int idx) {
    var i = idx + 1;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: c.isativo ? AppColors.secundaria : AppColors.grey,
            child: Text(i.toString()),
          ),
          title: c.isativo
              ? Text(c.nome)
              : Text(
                  c.nome,
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
         Divider(thickness: 1,)
      ],
    );
  }

  showExcluir(
    BuildContext context,
    Categoria dados,
  ) {
    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          widget.categoria.removeWhere((element) => element.id == dados.id);
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

  Future<void> _onClickExcuir(Categoria dados) async {
    var dado = dados ?? Categoria();
    dado.id = dados.id;
    await CategoriaApi.delete(context, dado);
  }



  void _onClickEdit(Categoria c) {
    push(
        context,
        CategoriaEdit(
          categoria: c,
        ));
  }
}
