
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor_edit.dart';
import 'package:unigran_tcc/screens/fornecedor/fornecedor_api.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class FornecedorListView extends StatefulWidget {
  final List<Fornecedor> fornecedor;
  FornecedorListView(this.fornecedor);

  @override
  _FornecedorListViewState createState() => _FornecedorListViewState();
}

class _FornecedorListViewState extends State<FornecedorListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Fornecedor> fornecedor2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();


  @override
  Widget build(BuildContext context) {
         return _grid(widget.fornecedor);
  }

  _grid(List<Fornecedor> fornecedor) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.fornecedor.length,
              itemBuilder: (context, index) {

                Fornecedor c = widget.fornecedor[index];
                  return _cardFornecedor(c,constraints,index);

              },
            ),
          ),
        );
      },
    );
  }


  _cardFornecedor(Fornecedor c, BoxConstraints constraints, int idx) {
    var i = idx+1;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor:c.isativo ?AppColors.secundaria:AppColors.grey,
            child: Text(i.toString()),),
          title: c.isativo? Text(c.nome):Text(c.nome,style: AppTextStyles.body_noAtive,),

          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(onTap: (){
                    pop(context);
                    _onClickEdit(c);

                  },
                      child: Text("Editar")),
                ),
              ),
              PopupMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(onTap: (){
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
  showExcluir(BuildContext context, Fornecedor dados, ) {

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
          widget.fornecedor.removeWhere((element) => element.id==dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text('${dados.nome} ' ),
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
  Future<void> _onClickExcuir(Fornecedor dados) async {

    var dado = dados ?? Fornecedor();
    dado.id = dados.id;
    await FornecedorApi.delete(context, dado);

  }




  void _onClickEdit(Fornecedor c) {
    push(context, FornecedorEdit(fornecedor: c,));
  }


}
