import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/screens/produto/Produto_bloc.dart';
import 'package:unigran_tcc/screens/produto/Produto_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_produto.dart';

class ProdutoPage extends StatefulWidget {
  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;
  final _bloc = ProdutoBloc();
  final BlocProduto blocProduto = BlocProvider.getBloc<BlocProduto>();
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Produto> produtos;
  List<Produto> lt;
  bool buscando = true;

  iniciaBloc() {
    _bloc.fetch(context).then((value) {
      setState(() {
        produtos = value;
        blocProduto.inPage.add(produtos);
        buscando = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }
  // List<PedidoItens> itens =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Novo Produto',
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: blocProduto.outPage,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 3)),
                  builder: (context, AsyncSnapshot snapshot) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            }
            lt = snap.data;

            if (lt.length == 0 && buscando == true) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (lt.length == 0 && buscando == false) {
              return Center(
                  child: Container(
                child: Text(
                  'Nenhum registro encontrado!',
                  style: TextStyle(color: Colors.red),
                ),
              ));
            } else {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: _admin(lt),
              );
            }
          }),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }

  _admin(List<Produto> produto) {
    return ProdutoListView(lt);
  }

  _onClickAdd() {
    setState(() {
      bloc_bloc.inPage.add(AppPages.produtoAdd);
    });
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(context);
  }

  refresh() {
    iniciaBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
