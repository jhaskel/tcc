import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/customer.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/utils/graficos/grafCol.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class GastosPorMes extends StatefulWidget {
  final int  escola;
  GastosPorMes({this.escola});

  @override
  _GastosPorMesState createState() => _GastosPorMesState();
}

class _GastosPorMesState extends State<GastosPorMes> {
  int get escola => widget.escola;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  int atual;

  iniciaBloc(){
   _blocItens.fetchTotalMesEscola(context, escola, ano);
  }

  @override
  void initState() {
  atual = escola;
   iniciaBloc();


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
  if(atual != escola){
  iniciaBloc();
  }
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
          listItens.sort((a, b) => a.id.compareTo(b.id));
          print('listItensx ${listItens}');
          for (var y in listItens) {
            print('aqui ${y.mes}');
          }

          List<Customer> list3 = [];
          int i2 = 0;

          print('listItensx ${listItens}');
          for (var c in listItens) {
            list3.add(Customer(c.mes, c.tot, Cores.colorList[i2]));
            i2++;
          }
          return GrafCol(list3,true);
        });
  }
}
