import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/customer.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/utils/bloc/bloc_produto.dart';
import 'package:unigran_tcc/utils/graficos/grafCol.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class ConsumoPorEscola extends StatefulWidget {
  final Produto produto;
  ConsumoPorEscola({this.produto});

  @override
  _ConsumoPorEscolaState createState() => _ConsumoPorEscolaState();
}

class _ConsumoPorEscolaState extends State<ConsumoPorEscola> {
  Produto get produto => widget.produto;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  int quantidade;
  int comprado = 0;
  int estoque = 0;
  final BlocProduto blocProduto = BlocProvider.getBloc<BlocProduto>();
  @override
  void initState() {
  quantidade = produto.quantidade.toInt();
  blocProduto.inQant.add(produto.quantidade.toInt());
  blocProduto.inComprado.add(0);
  blocProduto.inEstoque.add(quantidade);
    _blocItens.fetchProduto(context, produto.id);
    super.initState();
  }

  @override
  void dispose() {
    _blocItens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Ainda não existe pedidos para esta Escola");
          }
          if (!snapshot.hasData) {
            return Container();
          }
          List<PedidoItens> listItens = snapshot.data;
          var quant = listItens.map((e) => e.tot);
          comprado = quant.reduce((a, b) => a + b).toInt();


            blocProduto.inComprado.add(comprado);
            blocProduto.inEstoque.add(quantidade - comprado);


          listItens.sort((a, b) => a.id.compareTo(b.id));
          print('listItensx ${listItens}');
          for (var y in listItens) {
            print('aqui ${y.mes}');
          }
          List<Customer> list3 = [];
          int i2 = 0;

          print('listItensx ${listItens}');
          for (var c in listItens) {
            list3.add(Customer(c.nomec, c.tot, Cores.colorList[i2]));
            i2++;
          }
          return GrafCol(list3,false);
        });
  }
}
