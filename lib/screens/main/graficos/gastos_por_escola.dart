import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/customer.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/utils/graficos/grafCol.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class GastosPorEscola extends StatefulWidget {
  @override
  _GastosPorEscolaState createState() => _GastosPorEscolaState();
}

class _GastosPorEscolaState extends State<GastosPorEscola> {
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  @override
  void initState() {
    _blocItens.fetchTotalEscola(context, ano);
    // TODO: implement initState
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
          print('listItens ${listItens}');
          List<Customer> list = [];
          int i = 0;
          for (var c in listItens) {
            list.add(Customer(c.nomec, c.tot, Cores.colorList[i]));
            i++;
          }
          return GrafCol(list,true);
        });
  }
}
