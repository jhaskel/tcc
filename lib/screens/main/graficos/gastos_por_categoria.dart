import 'package:flutter/material.dart';
import 'package:unigran_tcc/models/customer.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:unigran_tcc/utils/graficos/piza.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class GastosPorCategoria extends StatefulWidget {
  final Usuario user;
  GastosPorCategoria({this.user});

  @override
  _GastosPorCategoriaState createState() => _GastosPorCategoriaState();
}

class _GastosPorCategoriaState extends State<GastosPorCategoria> {
  Usuario get user => widget.user;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;

  int ano = DateTime.now().year;
  int escola;
  @override
  void initState() {
    if (user == null) {
      escola = 0;
    } else {
      escola = user.escola;
    }

    if (escola == 0) {
      _blocItens.fetchTotalCategoria(context, ano);
    } else {
      _blocItens.fetchTotalCategoriaEscola(context, escola, ano);
    }

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
