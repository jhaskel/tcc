import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/cart/Cart.dart';
import 'package:unigran_tcc/screens/cart/Cart_api.dart';
import 'package:unigran_tcc/screens/comprar/Compras.dart';
import 'package:unigran_tcc/screens/comprar/Compras_api.dart';
import 'package:unigran_tcc/screens/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:unigran_tcc/screens/pedido/pedidoAdd/PedidoAdd_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';
import 'package:unigran_tcc/utils/bloc/cart_bloc.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/utils/utils.dart';

class CartPage extends StatefulWidget {
  final Usuario user;

  CartPage(this.user);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool iniciar = false;
  List<Cart> listCart;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  bool _showProgress = false;
  Usuario get user => widget.user;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  final BlocPedido blocPed = BlocProvider.getBloc<BlocPedido>();

  int _quant = 0;
  int step;
  int currentStep = 0;

  itensCart() async {
    final bloc = Provider.of<CartBloc>(context, listen: false);
    setState(() {
      listCart = bloc.get();
      iniciar = true;
      step = listCart.length;
    });
  }

  @override
  void initState() {
    itensCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: !_showProgress
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaria,
              foregroundColor: Colors.black,
              onPressed: () {
                _onClickSalvar(context);
              },
              icon: Icon(
                Icons.shopping_basket_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Finalizar Compra',
                style: AppTextStyles.heading15White,
              ),
            )
          : Container(),
    );
  }

  _body() {
    double altura = MediaQuery.of(context).size.height;
    final blocx = Provider.of<CartBloc>(context);
    return Stack(
      children: [
        StreamBuilder(
            stream: blocPed.outQuant,
            builder: (context, snapshot) {
              _quant = snapshot.data;
              print('quantt $_quant');
              return Column(
                children: [
                  iniciar
                      ? Container(
                          height: altura - 150,
                          child: ListView.builder(
                              itemCount: listCart.length,
                              itemBuilder: (context, index) {
                                Cart c = listCart[index];
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Row(children: [
                                          Flexible(
                                            flex: 8,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              c.alias,
                                              style: AppTextStyles.heading15,
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "R\$ ${formatador.format(c.valor)}  /  ${c.unidade}",
                                              style: AppTextStyles.heading15,
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            fit: FlexFit.tight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      child: InkWell(
                                                          onTap: () async {
                                                            decrement(c);
                                                          },
                                                          child: Icon(Icons
                                                              .indeterminate_check_box))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      child: Text(
                                                          "${c.quantidade}",
                                                          style: AppTextStyles
                                                              .heading15)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                      child: InkWell(
                                                          onTap: () async {
                                                            increment(c);
                                                          },
                                                          child: Icon(
                                                              Icons.add_box))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "R\$ ${formatador.format(c.quantidade * c.valor)} ",
                                              style: AppTextStyles.heading15,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ]),
                                        trailing: IconButton(
                                          onPressed: () {
                                            showExcluir(context, c);
                                          },
                                          icon: Icon(Icons.delete),
                                        )),
                                    Divider(
                                      height: 1,
                                    )
                                  ],
                                );
                              }),
                        )
                      : CircularProgressIndicator(),
                  Column(
                    children: [
                      Container(
                        color: AppColors.button,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Text(
                          'Valor do pedido R\$ ${formatador.format(blocx.total)} ',
                          style: AppTextStyles.bodyWhite20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
        _showProgress
            ? Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Aguarde....',
                        style: AppTextStyles.heading40White,
                      ),
                      CircularStepProgressIndicator(
                        totalSteps: step,
                        currentStep: currentStep,
                        stepSize: 10,
                        selectedColor: AppColors.secundaria,
                        unselectedColor: AppColors.grey,
                        padding: 0,
                        width: 150,
                        height: 150,
                        selectedStepSize: 15,
                        roundedCap: (_, __) => true,
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  showExcluir(BuildContext context, Cart c) {
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
          listCart.removeWhere((element) => element.id == c.id);
        });
        _onClickExcluir(c);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${c.alias} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse ítem?'),
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

  increment(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    blocx.increment(c);

    var quant = c.quantidade + 1;
    var total = quant * c.valor;
    // Cria o usuario
    var carr = c ?? Cart();
    carr.id = c.id;
    carr.quantidade = quant;
    carr.total = total;
    print("total${total}");
    await CartApi.update(context, carr);
  }

  decrement(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    if (c.quantidade > 1) {
      blocx.decrement(c);

      var quant = c.quantidade - 1;
      var total = quant * c.valor;
      // Cria o usuario
      var carr = c ?? Cart();
      carr.quantidade = quant;
      carr.total = total;
      print("total${total}");
      await CartApi.update(context, carr);
    }
  }

  Future<void> _onClickExcluir(Cart c) async {
    final blocx = Provider.of<CartBloc>(context, listen: false);
    blocx.remove(c);

    print('excluindo');
    var carr = c ?? Cart();
    carr.id = c.id;
    await CartApi.delete(context, carr);
    itensCart();
  }

  _onClickSalvar(BuildContext context) async {
    Compras itens;
    final blocx = Provider.of<CartBloc>(context, listen: false);

    setState(() {
      _showProgress = true;
    });

    var hoje = DateTime.now().toIso8601String();
    var mes = DateTime.now().month;

    //cria o pedido
    PedidoAdd pedido;
    setState(() {
      _showProgress = true;
    });

    var ped = pedido ?? PedidoAdd();
    ped.escola = user.escola;
    ped.status = Status.pedidoRealizado;
    ped.isativo = true;
    ped.createdAt = hoje;
    ped.modifiedAt = hoje;
    ped.isaf = false;
    ped.total = blocx.total;

    ApiResponse<bool> response =
        (await PedidoAddApi.save(context, ped)) as ApiResponse<bool>;
    var id = response.id;
    if (response.ok) {
      int qu = _quant + 1;
      blocPed.inQuant.add(qu);

      print('quantTT ${listCart.length}');

      for (var c in listCart) {
        print('PRODIDCART ${c.id}');
        var pedi = itens ?? Compras();
        pedi.pedido = id;
        pedi.produto = c.produto;
        pedi.categoria = c.categoria;
        pedi.fornecedor = c.fornecedor;
        pedi.escola = c.escola;
        pedi.alias = c.alias;
        pedi.quantidade = c.quantidade;
        pedi.valor = c.valor;
        pedi.total = c.total;
        pedi.createdAt = hoje;
        pedi.modifiedAt = hoje;
        pedi.ano = DateTime.now().year;
        pedi.unidade = c.unidade;
        pedi.status = Status.pedidoRealizado;
        pedi.isativo = true;
        pedi.af = 0;
        pedi.mes = getMes(mes);

        await ComprasApi.save(context, pedi);
        print('excluindo ${c.id}');
        var carr = c ?? Cart();
        carr.id = c.id;
        setState(() {
          currentStep++;
        });
        await CartApi.delete(context, carr);
      }

      blocx.removeAll();
    } else {
      alert(context, response.msg);
    }

    if (response.ok) {
      setState(() {
        showOrderPlace(context, id);
      });
    }

    setState(() {
      _showProgress = false;
    });
  }

  String getMes(int mes) {
    return Meses.meses[mes];
  }

  showOrderPlace(BuildContext context, int id) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        setState(() {
          bloc_bloc.inPage.add(AppPages.comprar);
        });
        pop(context);
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        setState(() {
          bloc_bloc.inPage.add(AppPages.pedido);
        });
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        width: 300,
        height: 600,
        child: Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/order_place.png',
                  height: 400,
                ),
                Text('Pedido Realizado', style: AppTextStyles.bodyLightGrey20),
                Text('Utilize o número abaixo',
                    style: AppTextStyles.bodyLightGrey20),
                Text('#$id', style: AppTextStyles.heading40),
              ],
            )),
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
}
