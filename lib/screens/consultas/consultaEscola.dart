import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/screens/consultas/graficos/gastos_por_categoria.dart';
import 'package:unigran_tcc/screens/consultas/graficos/gastos_por_mes.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:unigran_tcc/utils/utils.dart';

class ConsultaEscola extends StatefulWidget {
  Usuario user;
  final int escola;
  ConsultaEscola(this.user,this.escola);

  @override
  _ConsultaEscolaState createState() => _ConsultaEscolaState();
}

class _ConsultaEscolaState extends State<ConsultaEscola> {
 Usuario get user=>widget.user;
  int get escola=>widget.escola;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  List<Categoria> categorias;

  double total ;
  int quantAlunos ;
  double totalAgro ;
  double totalPnae;
  double totalPorEscola ;
  double valorPnePorEscola ;
  double porcentagemAgro;
  double totalPorAluno ;
  double totalTradicional ;
  double larg = 250;
  double alt = 100;
  int quantEscolas ;
  int atual;
  List<Color> cores = [Colors.blue, Colors.purple, Colors.orange, Colors.green];
  int alunos;
  int ano = DateTime.now().year;
  int totalAf ;
  //pega a quantidade de escolas
  Future<int> getQuantEscola() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantidade';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega o total gasto no ano
  Future<double> getTotal() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/itens/totalEscola/$escola/$ano';
    var response = await http.get(url, headers: headers);
    print(json.decode(response.body));
    return (json.decode(response.body));
  }

  //pega a quantidade de alunos matriculados na escola
  Future<int> getQuantAlunos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };
    var url = '$BASE_URL/escolas/quantAlunosEscola/$escola';
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
    var url = '$BASE_URL/itens/tradicionalEscola/$escola/$ano';
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
    var url = '$BASE_URL/itens/familiarEscola/$escola/$ano';
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

  iniciaBloc(){

   total = 0;
   quantAlunos = 1;
   totalAgro = 0;
   totalPnae = 1;
   totalPorEscola = 0;
   valorPnePorEscola = 0;
   porcentagemAgro = 0;
   totalTradicional = 0;
   quantEscolas = 0;
   totalAf = 0;
  atual = escola;
   getQuantEscola().then((int) {
      setState(() {
        quantEscolas = int;
        print('quantEscolas${quantEscolas}');
      });
    });

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
        print('quantAlunos${quantAlunos}');
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
        print('totalAgro${totalAgro}');
      });
    });
    //total do pnae
    getTotalPnae().then((double) {
      setState(() {
        totalPnae = double;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    //quantidade de escola
    iniciaBloc();

  }

  @override
  Widget build(BuildContext context) {
  if(atual != escola){
  iniciaBloc();
  }

  print('KKKKKKKK$escola');
    totalPorAluno = total / quantAlunos;
    if (totalPnae > 0 && totalAgro > 1) {
      valorPnePorEscola = totalPnae / quantEscolas;

      porcentagemAgro = (totalAgro / valorPnePorEscola) * 100;
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
                  'Gastos Mensais da Escola',
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
                        escola: escola,
                      )),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 1,
                  child:
                      Card(elevation: 5, child: GastosPorCategoria(escola: escola)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
