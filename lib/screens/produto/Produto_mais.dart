import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/pro.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/screens/produto/Produto_bloc.dart';
import 'package:unigran_tcc/screens/produto/Produto_detalhe.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class ProdutoMais extends StatefulWidget {
  @override
  _ProdutoMaisState createState() => _ProdutoMaisState();
}

class _ProdutoMaisState extends State<ProdutoMais> {
  List<PedidoItens> _allContacts = [];
  StreamController<List<PedidoItens>> _contactStream =
      StreamController<List<PedidoItens>>();
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  ScrollController _controller = ScrollController();

  final _blocItens = PedidoItensBloc();
  final _blocProduto = ProdutoBloc();
  List<PedidoItens> pedidos;
  List<Produto> listProdutos;
  Key key;

  double larg = 250;
  double alt = 100;
  double valorTotal = 0;
  double totalProduto = 0;
  double totalLicitado = 0;

  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  bool _buscaProduto = true;

  iniciaBloc(int produto) {
   Produto pro;
    _blocProduto.fetchId(context,produto).then((value) {
      setState(() {
        print('X2');
        listProdutos = value;
        pro = listProdutos.first;
        _buscaProduto = false;
      });
    }).then((value) => _onClickDetalhe(pro));
  }

  @override
  void initState() {
    _blocItens.fetchMaisPedidos(context, ano).then((value) {
      setState(() {
        for (var x in value) {
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);
      });
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("N??o foi poss??vel buscar os itens do pedido");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 50,
                      child: Text(
                        'Produtos Mais Pedido',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                AppBarTextField(
                  backgroundColor: Colors.transparent,
                  title: Text("Buscar...."),
                  onBackPressed: _onRestoreAllData,
                  onClearPressed: _onRestoreAllData,
                  onChanged: _onSimpleSearch2Changed,
                  autofocus: true,
                  elevation: 1,
                  clearBtnIcon: Icon(
                    Icons.clear,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.black12,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Produto'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Quant'),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Unid'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _controller,
                    isAlwaysShown: true,
                    showTrackOnHover: true,
                    thickness: 10,
                    radius: Radius.circular(15),
                    child: StreamBuilder<List<PedidoItens>>(
                        stream: _contactStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return TextError(
                                "N??o foi poss??vel buscar os dados!");
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<PedidoItens> contacts =
                              snapshot.hasData ? snapshot.data : [];

                          return ListView.builder(
                            controller: _controller,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              PedidoItens pro = contacts[index];
                              var tot1 = pro.valor;
                              var tot2 = tot1 * pro.tot;
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                    print('X1');
                                    await iniciaBloc(pro.produto);
                                      print('X3');
                                  //    !_buscaProduto??_onClickDetalhe(produto);
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(pro.alias),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(pro.tot.toString()),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(pro.unidade),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total Gasto'),
                                        Text('R\$ ${formatador.format(tot2)}'),
                                      ],
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _blocItens.dispose();
    _contactStream.close();
    super.dispose();
  }

  void _onSimpleSearch2Changed(String value) {
    List<PedidoItens> foundContacts = _allContacts
        .where((PedidoItens contact) =>
            contact.alias.toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();
    this._contactStream.add(foundContacts);
  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }

  void _onClickDetalhe(Produto pro) {
    push(
        context,
        ProdutoDetalhe(
          produto: pro,
        ));
  }
}
