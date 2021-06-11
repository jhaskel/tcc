import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/main/graficos/consumo_escola.dart';
import 'package:unigran_tcc/screens/main/graficos/consumo_nivel.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/utils/bloc/bloc_produto.dart';
import 'package:unigran_tcc/utils/bloc/categoria_bloc.dart';
import 'package:unigran_tcc/utils/bloc/fornecedor_bloc.dart';

class ProdutoDetalhe extends StatefulWidget {
  final Produto produto;
  ProdutoDetalhe({this.produto});

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  Produto get dados => widget.produto;
  bool _showProgress = false;
  bool _isLoading = true;
  bool _isLoadingCat = true;
  int comprado = 0;
  int estoque = 0;

  final _bloc = PedidoItensBloc();
  List<PedidoItens> listItens;
  List<Fornecedor> listFornecedores;
  Fornecedor fornecedor;
  List<Categoria> listCategorias;
  Categoria categoria;
  final BlocController bloc = BlocProvider.getBloc<BlocController>();
  final BlocProduto blocPro = BlocProvider.getBloc<BlocProduto>();

  var formatador = NumberFormat("#,##0.00", "pt_BR");

  iniciaBloc() {
    Provider.of<FornecedorBloc>(context, listen: false)
        .fetchId(context, dados.fornecedor)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<CategoriaBloc>(context, listen: false)
        .fetchId(context, dados.categoria)
        .then((_) {
      setState(() {
        _isLoadingCat = false;
      });
    });
  }

  @override
  void initState() {
    _bloc.fetchProduto(context, dados.id);
    iniciaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(dados);
    return !_showProgress
        ? Scaffold(
            appBar: AppBar(
              title: Text(dados.alias),
              centerTitle: true,
            ),
            body: _body(),
          )
        : CircularProgressIndicator();
  }

  _body() {
    print('X2');
    final blocCat = Provider.of<CategoriaBloc>(context);
    if (blocCat.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (blocCat.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    }
    listCategorias = blocCat.lista;
    categoria = listCategorias.first;

    final bloc = Provider.of<FornecedorBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      listFornecedores = bloc.lista;
    fornecedor = listFornecedores.first;
    return ListView(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: 400,
                child: Image.network(dados.image),
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Descrição:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              dados.nome,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Preço:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Row(children: [
                              Text(
                                "R\$ ${formatador.format(dados.valor)}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(dados.unidade)
                            ])),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Licitado:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Row(children: [
                              Text(
                                dados.quantidade.toString(),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(dados.unidade)
                            ])),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Comprado:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Row(children: [
                              StreamBuilder(
                                stream: blocPro.outComprado,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data.toString(),
                                  );
                                }
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(dados.unidade)
                            ])),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Estoque:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Row(children: [
                              StreamBuilder(
                                stream: blocPro.outEstoque,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data.toString(),
                                  );
                                }
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(dados.unidade)
                            ]))
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Fornecedor:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              fornecedor.nome,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text('Categoria:'),
                        ),
                        Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: Text(
                              categoria.nome,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Text(
                  'Quantidade Por Escola',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ), //B
                //BoxDecoration
              ), //Container
            ), //Flexible
            SizedBox(
              width: 20,
            ), //SizedBox
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Text(
                  'Quantidade por Nivel Escolar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ), //B
              ), //Container
            ) //Flexible
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 400,
          width: 1000,
          child: Row(
            children: [
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(
                      elevation: 5,
                      child: ConsumoPorEscola(
                        produto: dados,
                      )),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(
                      elevation: 5,
                      child: ConsumoPorNivel(
                        produto: dados.id,
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
