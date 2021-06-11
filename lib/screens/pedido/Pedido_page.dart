import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pedido/Pedido.dart';
import 'package:unigran_tcc/screens/pedido/Pedido_bloc.dart';
import 'package:unigran_tcc/screens/pedido/pedido_detalhe.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/utils/nav.dart';

class PedidoPage extends StatefulWidget {
  final Usuario user;
  PedidoPage(this.user);

  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => widget.user;
  final _bloc = PedidoBloc();
  final BlocPedido blocPedido = BlocProvider.getBloc<BlocPedido>();

  var formatador = NumberFormat("#,##0.00", "pt_BR");
  //controle do scroll
  ScrollController _controller = ScrollController();
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Pedido> pedidos;
  List<Pedido> lt;
  bool buscando = true;
  int idEscola = 0;

  iniciaBloc() {
    print("userr${user.escola}");

    if (user.escola != 0) {
      _bloc.fetchEscola(context, user.escola).then((value) {
        setState(() {
          pedidos = value;
          if (pedidos != null) {
            blocPedido.inPage.add(pedidos);
            buscando = false;
          }
          buscando = false;
        });
      });
    } else {
      _bloc.fetch(context).then((value) {
        setState(() {
          pedidos = value;
          if (pedidos != null) {
            blocPedido.inPage.add(pedidos);
            buscando = false;
          }
          buscando = false;
        });
      });
    }
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
          stream: blocPedido.outPage,
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

  _admin(List<Pedido> pedido) {

    return _grid(pedido);
  }

  _grid(List<Pedido> pedido) {


    return LayoutBuilder(
      builder: (context, constraints) {
      var map1 = lt.map((e) => e.nomedaescola).toSet().toList();
           var map2 = lt.map((e) => e.escola).toSet().toList();
             print('ma1 $map1');
             print('ma2 $map2');
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
            user.escola == 0?Container(
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
                            color: list2[index] == idEscola ? Colors.green : Colors.grey,
                            hoverColor: AppColors.green,
                            highlightColor: AppColors.primaria,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            child: Text(list1[index],
                                style: TextStyle(color: Colors.white)),
                          )));
                },
              ),
            ):Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Scrollbar(
                  controller: _controller,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: pedido.length,
                    itemBuilder: (context, index) {
                      Pedido c = pedido[index];
                      return _cardPedido(c, constraints, index);
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

  _cardPedido(Pedido p, BoxConstraints constraints, int idx) {
    DateTime crea = DateTime.parse(p.createdAt);

    if(p.escola == idEscola ) {
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
              Text(p.nomedaescola),
              Text('R\$  ${formatador.format(p.total)}'),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${p.id}'),
              Text(
                p.status,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          trailing: Column(
            children: [
              MergeSemantics(
                child: CupertinoSwitch(
                  value: p.isaf,
                  onChanged: null,
                  activeColor: AppColors.primaria,
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
    }else if(idEscola ==0){
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
              Text(p.nomedaescola),
              Text('R\$  ${formatador.format(p.total)}'),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${p.id}'),
              Text(
                p.status,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          trailing: Column(
            children: [
              MergeSemantics(
                child: CupertinoSwitch(
                  value: p.isaf,
                  onChanged: null,
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
    }else{
    return Container();
    }

  }

  void _onClickDetalhe(Pedido c) async {
    bool result = await push(
        context,
        PedidoDetalhe(
          pedido: c,
          user: widget.user,
        ));
    if (result == true) {
      iniciaBloc();
    }
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(context);
  }

  refresh() {
    iniciaBloc();
  }

  Future<void> _onRefreshEscola(int id) {
    setState(() {
      idEscola = id;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
