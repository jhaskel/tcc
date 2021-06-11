import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/comprar/Compras.dart';
import 'package:unigran_tcc/screens/comprar/compras_bloc.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/af/Af.dart';
import 'package:unigran_tcc/screens/af/Af_bloc.dart';
import 'package:unigran_tcc/screens/af/af_detalhe.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:intl/intl.dart';

class AfPage extends StatefulWidget {
  final Usuario user;
  AfPage(this.user);

  @override
  _AfPageState createState() => _AfPageState();
}

class _AfPageState extends State<AfPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => widget.user;
  final _bloc = AfBloc();
  final _blocItens = ComprasBloc();
  List<Compras> listItens;
  bool _showProgress = false;
  int idFornecedor = 0;

  final BlocAf blocAf = BlocProvider.getBloc<BlocAf>();
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Af> afs;
  List<Af> lt;
  bool buscando = true;
  //controle do scroll
  ScrollController _controller = ScrollController();

  List<Af> af2;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  iniciaBloc() {
    _bloc.fetch(context).then((value) {
      setState(() {
        afs = value;
        blocAf.inPage.add(afs);
        buscando = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
          stream: blocAf.outPage,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 3)),
                  builder: (context, AsyncSnapshot snapshot) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            }
            lt = snap.data;
            if (lt.length == 0 && buscando == true) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (lt.length == 0 && buscando == false) {
              return Center(
                  child: Container(
                child: Text(
                  'Nenhum registro encontrado!',
                  style: TextStyle(color: Colors.red),
                ),
              ));
            } else {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: _admin(lt),
              );
            }
          }),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }

  _admin(List<Af> af) {
    //  return  AfListView(lt,user);
    return LayoutBuilder(

      builder: (context, constraints) {
       var map1 = lt.map((e) => e.nomefor).toSet().toList();
           var map2 = lt.map((e) => e.fornecedor).toSet().toList();
             var list1=['Todas'];
             var list2=[0];
             for(var x in map1){
             list1.add(x);
             }
              for(var x in map2){
             list2.add(x);
             }

        return Column(
        children: [
        Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list1.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: MaterialButton(
                            elevation: 5,
                            onPressed: () => _onRefreshEscola(list2[index]),
                            color: list2[index] == idFornecedor ? Colors.green : Colors.grey,
                            hoverColor: AppColors.green,
                            highlightColor: AppColors.primaria,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            child: Text(list1[index],
                                style: TextStyle(color: Colors.white)),
                          )));
                },
              ),
            ),Expanded(
                          child: Container(
              padding: EdgeInsets.all(16),
              child: Scrollbar(
                controller: _controller,
                isAlwaysShown: true,
                child: ListView.builder(
                  controller: _controller,
                  itemCount: af.length,
                  itemBuilder: (context, index) {
                    Af c = af[index];

                    return _cardAf(c, constraints, index);
                  },
                ),
              ),
          ),
            ),
        ],

        );
      },
    );
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(context);
  }

  refresh() {
    iniciaBloc();
  }
  _cardAf(Af p, BoxConstraints constraints, int idx) {
    DateTime crea = DateTime.parse(p.createdAt);
    if(p.fornecedor == idFornecedor ) {
    return Column(
      children: [
        ListTile(
            onTap: () {
              _onClickDetalhe(p);
            },
            leading: Container(
              color: AppColors.secundaria,
              height: 50,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      DateFormat("dd/MM").format(crea),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat("yyyy").format(crea),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Row(
                  children: [
                    Text('#${p.code.toString()}'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(p.nomefor),
                  ],
                ),
                Text('R\$  ${formatador.format(p.tot)}')
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            subtitle: Text(p.status),
            trailing: MergeSemantics(
              child: CupertinoSwitch(
                value: p.isenviado,
                onChanged: null,
                activeColor: AppColors.primaria,
              ),
            )
        ),
        Divider(),
      ],
    );
    }else if(idFornecedor == 0){
    return Column(
      children: [
        ListTile(
            onTap: () {
              _onClickDetalhe(p);
            },
            leading: Container(
              color: AppColors.secundaria,
              height: 50,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      DateFormat("dd/MM").format(crea),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat("yyyy").format(crea),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Row(
                  children: [
                    Text('#${p.code.toString()}'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(p.nomefor),
                  ],
                ),
                Text('R\$  ${formatador.format(p.tot)}')
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            subtitle: Text(p.status),
            trailing: MergeSemantics(
              child: CupertinoSwitch(
                value: p.isenviado,
                onChanged: null,
              ),
            )
        ),
        Divider(),
      ],
    );
    }else{
    return Container();
    }

  }

  void _onClickDetalhe(Af c) async {
    bool result = await push(context, AfDetalhe(af: c, user: widget.user));
    if (result == true) {
      iniciaBloc();
    }
  }
   Future<void> _onRefreshEscola(int id) {
    setState(() {
      idFornecedor = id;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
