import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/af/Af.dart';
import 'package:unigran_tcc/screens/af/afAdd/Af.dart';
import 'package:unigran_tcc/screens/af/afAdd/af_api.dart';
import 'package:unigran_tcc/screens/af/af_bloc.dart';
import 'package:unigran_tcc/screens/af/af_detalhe.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/utils/utils.dart';

class FornecedorHome extends StatefulWidget {
  final Usuario user;
  FornecedorHome(this.user);

  @override
  _FornecedorHomeState createState() => _FornecedorHomeState();
}

class _FornecedorHomeState extends State<FornecedorHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => widget.user;
  final _bloc = AfBloc();
  final BlocAf blocAf = BlocProvider.getBloc<BlocAf>();

  var formatador = NumberFormat("#,##0.00", "pt_BR");
  //controle do scroll
  ScrollController _controller = ScrollController();
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Af> afs;
  List<Af> lt;
  bool buscando = true;

  iniciaBloc() {
    _bloc.fetchFornecedor(context, user.escola).then((value) {
      setState(() {
        afs = value;
        print("y3escola${afs}");
        if (afs != null) {
          blocAf.inPage.add(afs);
          buscando = false;
        }
        buscando = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iniciaBloc();
  }
  // List<PedidoItens> itens =[];

  @override
  Widget build(BuildContext context) {
    print('essa pagina');
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
              // lt.sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
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

  _admin(List<Af> pedido) {
    return _grid(pedido);
  }

  _grid(List<Af> pedido) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: pedido.length,
              itemBuilder: (context, index) {
                Af c = pedido[index];
                return _cardPedido(c, constraints, index);
              },
            ),
          ),
        );
      },
    );
  }

  _cardPedido(Af p, BoxConstraints constraints, int idx) {
    DateTime crea = DateTime.parse(p.createdAt);
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
              Text(p.nomefor),
              Text('R\$  ${formatador.format(p.tot)}'),
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
                  value: getStatus(p.status),
                  onChanged: null,
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  void _onClickDetalhe(Af c) async {

     push(context,AfDetalhe(af: c,user: widget.user,));
     alteraStatus(c);
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(context);
  }
  bool getStatus(String status){
    if(status == Status.pedidoFornecedor){
    return false;
    }else{
    return true;
    }


  }

  refresh() {
    iniciaBloc();
  }

  Future<void> alteraStatus(Af af) async {
  AfAdd afAdd;
   afAdd =  AfAdd(
      id: af.id,
      fornecedor: af.fornecedor,
      code: af.code,
      isativo: af.isativo,
      isenviado: af.isenviado,
      createdAt: af.createdAt,
      status: af.status,
    );

    var afs = afAdd ?? AfAdd();
    afs.status = Status.aguardandoEntrega;
    await AfAddApi.save(context, afs);
    iniciaBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
