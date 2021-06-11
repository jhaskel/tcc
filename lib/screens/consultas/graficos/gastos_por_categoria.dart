import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/customer.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/utils/graficos/piza.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class GastosPorCategoria extends StatefulWidget {
  final int escola;
  GastosPorCategoria({this.escola});

  @override
  _GastosPorCategoriaState createState() => _GastosPorCategoriaState();
}

class _GastosPorCategoriaState extends State<GastosPorCategoria> {
  int get escola=>widget.escola;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  int atual;


  iniciaBloc(){
   _blocItens.fetchTotalCategoriaEscola(context, escola, ano);

  }

  @override
  void initState() {
  atual = escola;
  iniciaBloc();





    // TODO: implement initState
    super.initState();
  }

  List<Customer> list2 = [];
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
    return Container(
      child: StreamBuilder(
          stream: _blocItens.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return TextError("Ainda não existe pedidos para esta Escola");
            }
            if (!snapshot.hasData) {
              return Container();
            }

            List<PedidoItens> listItens = snapshot.data;
            int i2 = 0;
            list2.clear();
            for (var c in listItens) {
              list2.add(
                  Customer(c.nomec, c.tot.toDouble(), Cores.colorList[i2]));
              i2++;
            }
            return Piza(list2);
          }),
    );
  }
}
