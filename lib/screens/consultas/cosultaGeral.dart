import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/screens/main/graficos/gastos_por_categoria.dart';
import 'package:unigran_tcc/screens/main/graficos/gastos_por_escola.dart';
import 'package:unigran_tcc/screens/main/graficos/gastos_por_mes.dart';
import 'package:unigran_tcc/screens/main/graficos/media_por_alunos.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:unigran_tcc/utils/utils.dart';

class ConsultaGeral extends StatefulWidget {
final Usuario user;
  ConsultaGeral(this.user);

  @override
  _ConsultaGeralState createState() => _ConsultaGeralState();
}

class _ConsultaGeralState extends State<ConsultaGeral> {
 var formatador = NumberFormat("#,##0.00", "pt_BR");
  final BlocPedido blocPedido = BlocProvider.getBloc<BlocPedido>();
  final BlocAf blocaf = BlocProvider.getBloc<BlocAf>();


  List<Categoria> categorias;
  Usuario get user => widget.user;
  double total = 0;
  int quantAlunos = 1;
  double totalAgro = 0;
  double totalPnae = 1;
  double totalPorEscola = 0;
  double valorPnePorEscola = 0;
  double porcentagemAgro = 0;
  double totalPorAluno = 1;
  double totalDiversos = 0;
  double totalTradicional = 0;
  double larg = 250;
  double alt = 100;
    int afSemEnviar = 0;
  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  int totalAf = 0;
  int pedidoSemAf = 0;
  //pega o total gasto no ano
  Future<double> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/total/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega a quantidade de alunos matriculados
  Future<int> getQuantAlunos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantAlunos';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o gasto de alimentos sem agriculatura familiar
  Future<double> getTradicional() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/tradicional/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o gasto de alimentos só da  agriculatura familiar
  Future<double> getFamiliar() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/familiar/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o valor total do pnae
  Future<double> getTotalPnae() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

    var url = '$BASE_URL/pnae/soma/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }
   //pega o total de pedidos sem af
  Future<int> getPedidoSemAf() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/pedidos/pedidoSemAf';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }
  //pega o total de pedidos sem af
  Future<int> getAfEnviada() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/af/afEnviada';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    //gastos no ano
    getTotal().then((double) {
      setState(() {
        total = double;
      });
    });
    //quantidade de alunos
    getQuantAlunos().then((int) {
      setState(() {
        quantAlunos = int;
      });
    });
    //gastos com alimento sem agrofamiliar
    getTradicional().then((double) {
      setState(() {
        totalTradicional = double;
      });
    });

    //gastos com alimento da agrofamiliar
    getFamiliar().then((double) {
      setState(() {
        totalAgro = double;
      });
    });
    //total do pnae
    getTotalPnae().then((double) {
      setState(() {
        totalPnae = double;
      });
    });
    //quantidade de pedidos sem Af
    getPedidoSemAf().then((int) {
      setState(() {
        pedidoSemAf = int;

      });
      print('pedidoSemAf $pedidoSemAf');
      blocPedido.inQuant.add(pedidoSemAf);
    });
    //quantidade de af sem enviar
    getAfEnviada().then((int) {
      setState(() {
        pedidoSemAf = int;
      });
      print('pedidoSemAf $pedidoSemAf');
      blocaf.inQuant.add(pedidoSemAf);
    });
  }



  @override
  Widget build(BuildContext context) {
    totalPorAluno = total / quantAlunos;
    if (totalPnae > 0 && totalAgro > 1) {
      print('totalagro $totalAgro / totalpne $totalPnae');
      print('totalagro $totalAgro / totalpne $totalPnae * 100 ');

      porcentagemAgro = (totalAgro / totalPnae) * 100;
    }
    return ListView(
      children: [
      SizedBox(height: 10,),
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[0],
                height: alt,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R\$ ${formatador.format(total)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Total gasto no Ano',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
               color: CorContainer().cores[1],
                height: alt,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R\$ ${formatador.format(totalPorAluno)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Gastor por aluno',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[2],
                height: alt,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R\$ ${formatador.format(totalTradicional)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Tradicional',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                )),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                color: CorContainer().cores[3],
                height: alt,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${porcentagemAgro.toStringAsFixed(2)} %',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Agro Familiar',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                )),
              ),
            ),
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
                  'Gastos Mensais',
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
                  'Gastos Por Categoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ), //B
              ), //Container
            ) //Flexible
          ],
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
                      child: GastosPorMes(
                        user: user,
                      )),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(
                      elevation: 5,
                      child: GastosPorCategoria(
                        user: user,
                      )),
                ),
              ),
            ],
          ),
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
                  'Gastos Anual Por Escola',
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
                  'Média de Gastos Por Alunos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ), //B
              ), //Container
            ) //Flexible
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 400,
          width: 1000,
          child: Row(
            children: [
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(elevation: 5, child: GastosPorEscola()),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child: Card(elevation: 5, child: MediaPorAlunos()),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
