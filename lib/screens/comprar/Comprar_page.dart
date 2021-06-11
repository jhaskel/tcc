import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/cart/Cart.dart';
import 'package:unigran_tcc/screens/cart/Cart_bloc.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/comprar/Comprar_listview.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/screens/produto/Produto_bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/categ_bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_produto.dart';
import 'package:unigran_tcc/utils/bloc/cart_bloc.dart';
import 'package:unigran_tcc/utils/bloc/categoria_bloc.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class ComprarPage extends StatefulWidget {
  final Usuario user;

  ComprarPage(this.user);

  @override
  _ComprarPageState createState() => _ComprarPageState();
}

class _ComprarPageState extends State<ComprarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => widget.user;
  final _bloc = ProdutoBloc();
  final _blocCart = CartBlocc();
  final BlocProduto blocProduto = BlocProvider.getBloc<BlocProduto>();
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  int idCategoria;
  List<Categoria> listCategorias;

  List<Cart> lisCart;
  List<int> itens = [];

  List<Produto> produtos;
  List<Produto> lt;
  List<Categoria> ltc;
  bool buscandoCat = true;
  bool buscandoCart = true;
  bool buscandoPro = true;

  iniciaBloc() {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    _blocCart.fetchEscola(context, user.escola).then((value) {
      setState(() {
        lisCart = value;
        blocx.removeAll();
        blocx.itens = 0;
        for (var x in lisCart) {
          blocx.add(Cart(
            id: x.id,
            produto: x.id,
            alias: x.alias,
            quantidade: x.quantidade,
            valor: x.valor,
            unidade: x.unidade,
            categoria: x.categoria,
            fornecedor: x.fornecedor,
            escola: x.escola,
            cod: x.cod,
            createdAt: x.createdAt,
            total: x.total,
          ));
          itens.add(x.produto);
          buscandoCart = false;
        }
      });
    });

    Provider.of<CategoriaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        listCategorias = value;
        buscandoCat = false;
      });
    });

    _bloc.fetch(context).then((value) {
      setState(() {
        produtos = value;
        blocProduto.inPage.add(produtos);
        buscandoPro = false;
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
      body: _body(),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }

  _body() {
    final blocCat = Provider.of<CategoriaBloc>(context);
    if (blocCat.lista.length == 0 && buscandoCat) {
      return Center(child: CircularProgressIndicator());
    } else if (blocCat.lista.length == 0 && !buscandoCat) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      ltc = blocCat.lista;
    return Container(
      child: StreamBuilder(
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

            if (lt.length == 0 && buscandoPro == true) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (lt.length == 0 && buscandoPro == false) {
              return Center(
                  child: Container(
                child: Text(
                  'Nenhum registro encontrado!',
                  style: TextStyle(color: Colors.red),
                ),
              ));
            } else {
              if (ltc.length > 0) {
                return _admin(lt, ltc);
              }
            }
          }),
    );
  }

  _admin(List<Produto> lt, List<Categoria> categorias) {
    if (idCategoria == null) {
      idCategoria = ltc.first.id;
    }
    return Column(
      children: [
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              Categoria c = categorias[index];
              return c.isativo
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: MaterialButton(
                            elevation: 5,
                            onPressed: () =>
                                _onRefreshCategoria(c.id, listCategorias),
                            color: c.id == idCategoria
                                ? Colors.green
                                : Colors.grey,
                            hoverColor: Colors.orange[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            child: Text(c.nome,
                                style: TextStyle(color: Colors.white)),
                          )))
                  : Container();
            },
          ),
        ),
        Expanded(child: ComprarListView(lt, idCategoria, user, itens))
      ],
    );
  }

  void _onClickAdd() async {
    setState(() {
      bloc_bloc.inPage.add(AppPages.produtoAdd);
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _blocCart.dispose();

    super.dispose();
  }

  Future<void> _onRefreshCategoria(int id, List<Categoria> listCategorias) {
    setState(() {
      idCategoria = id;
    });
  }
}
