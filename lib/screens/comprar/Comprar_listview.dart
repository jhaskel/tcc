import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/cart/Cart.dart';
import 'package:unigran_tcc/screens/cart/Cart_api.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/cart_bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:intl/intl.dart';

class ComprarListView extends StatefulWidget {
  List<Produto> produto;
  int idCategoria;
  Usuario user;
  List<int> itens;
  ComprarListView(this.produto, this.idCategoria, this.user, this.itens);

  @override
  _ComprarListViewState createState() => _ComprarListViewState();
}

class _ComprarListViewState extends State<ComprarListView> {
  Usuario get user => widget.user;
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Produto> produto2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  List<Produto> produto;
  int get idCategoria => widget.idCategoria;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  final tQuantidade = TextEditingController();

  List<Cart> tt;

  itensCart() async {
    final bloc = Provider.of<CartBloc>(context, listen: false);
    tt = await bloc.get();
  }

  @override
  void initState() {
    itensCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CartBloc>(context);
    itensCart();

    return Scaffold(
      body: _grid(widget.produto, bloc),
      floatingActionButton: bloc.itens > 0
          ? FloatingActionButton(
              onPressed: () {
                bloc_bloc.inPage.add(AppPages.cart);
              },
              backgroundColor: AppColors.button,
              child: Tooltip(
                message: '${bloc.itens}',
                child: Text(
                  '${bloc.itens}',
                  style: AppTextStyles.bodyWhite20,
                ),
              ),
            )
          : Container(),
    );
  }

  _grid(List<Produto> produto, CartBloc bloc) {
    var listFilter =
        widget.produto.where((e) => e.categoria == idCategoria).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        var largura = constraints.maxWidth;
        var colunas = largura > 1100 ? 6 : 4;
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colunas,
                childAspectRatio: .7,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              controller: _controller,
              itemCount: listFilter.length,
              itemBuilder: (context, index) {
                Produto c = listFilter[index];
                return _cardProduto(c, constraints, index, bloc);
              },
            ),
          ),
        );
      },
    );
  }

  _cardProduto(Produto c, BoxConstraints constraints, int idx, CartBloc bloc) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Center(
              child: c.image == null || c.image == ''
                  ? Image.asset(
                      'assets/images/sem_imagem.png',
                      height: 90,
                    )
                  : Image.network(
                      c.image,
                      height: 90,
                    ),
            ),
          ),


          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text('R\$ ${formatador.format(c.valor)}'),
                ),
                Container(
                  child: Text(
                    c.unidade ?? "",
                  ),
                ),
              ],
            ),
          ),
          !widget.itens.contains(c.id)
              ? MaterialButton(
                  onPressed: () {
                    showComprar(context, c, bloc);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  color: AppColors.button,
                  hoverColor: AppColors.green,
                  child: Text(
                    'Comprar',
                    style: AppTextStyles.heading15White,
                  ))
              : MaterialButton(
                  onPressed: () {},
                  color: AppColors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  child: Text(
                    'Cart',
                    style: AppTextStyles.heading15White,
                  )),
          Container(
            child: Center(
              child: Text(
                c.alias ?? "",
              ),
            ),
          ),
          c.agrofamiliar
              ? Container(
                  width: double.infinity,
                  color: Colors.green,
                  height: 15,
                  child: Text(
                    'Agric. Familiar',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(
                  height: 15,
                ),
        ],
      ),
    );
  }

  showComprar(
    BuildContext context,
    Produto c,
    CartBloc bloc,
  ) {
    double largura = 300;

    Widget comprarButton = MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Adicionar ao Carrinho",
              style: AppTextStyles.heading15White,
            )
          ],
        ),
      ),
      color: AppColors.button,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      onPressed: () async {
        _onClickSalvar(context, c, bloc);
        setState(() {
          widget.produto.removeWhere((element) => element.id == c.id);
        });

        pop(context);
      },
    );

    //configura o AlertDialog

    AlertDialog alert = AlertDialog(
      title: Container(
        width: largura,
        child: Row(
          children: [
            Flexible(
                flex: 6,
                fit: FlexFit.tight,
                child: Text(
                  '${c.alias} ',
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      pop(context);
                    }))
          ],
        ),
      ),
      content: Container(
        width: largura,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 90,
                child: Image.network(
                  c.image,
                  height: 90,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: AppColors.primaria,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    c.unidade,
                    style: AppTextStyles.body11White,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Text(
                  c.alias,
                  style: AppTextStyles.heading15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Text(
                  'R\$ ${formatador.format(c.valor)}',
                  style: AppTextStyles.body11,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: TextFormField(
                  autofocus: true,
                  controller: tQuantidade,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: 'Quantidade'),
                  validator: (value) =>
                      value.isEmpty ? 'Campo precisa ser preenchido' : null,
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: comprarButton,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Descrição', style: AppTextStyles.bodyTitleBold)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 300,
                  child: Text(
                    c.nome,
                    style: AppTextStyles.body11,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  )),
            ),
          ],
        ),
      ),
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          height: 600,
          child: alert,
        );
      },
    );
  }

  Future<void> _onClickSalvar(
      BuildContext context, Produto c, CartBloc bloc) async {
    print('colocou no car ${c.alias}');

    String quant = tQuantidade.text;
    double quantidade;
    quantidade = double.parse(quant);
    double total = quantidade * c.valor;
    quantidade = double.parse(quant);
    print('total ${quantidade}');

    Cart cartt;
    var cart = cartt ?? Cart();
    cart.produto = c.id;
    cart.categoria = c.categoria;
    cart.fornecedor = c.fornecedor;
    cart.unidade = c.unidade;
    cart.cod = c.code;
    cart.alias = c.alias;
    cart.escola = user.escola;
    cart.createdAt = DateTime.now().toIso8601String();
    cart.valor = c.valor;
    cart.quantidade = quantidade;
    cart.total = total;

    ApiResponse<bool> response = await CartApi.save(context, cart);
    int idCart = response.id;
    print('idCart$idCart');
    tQuantidade.clear();

    bloc.add(Cart(
      id: idCart,
      produto: c.id,
      alias: c.alias,
      quantidade: quantidade,
      valor: c.valor,
      unidade: c.unidade,
      categoria: c.categoria,
      fornecedor: c.fornecedor,
      escola: user.escola,
      cod: c.code,
      createdAt: DateTime.now().toIso8601String(),
      total: total,
    ));
    itensCart();
  }
}


