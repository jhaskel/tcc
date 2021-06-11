import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pnae/Pnae.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/pnae_bloc.dart';


class PnaePage extends StatefulWidget {
  @override
  _PnaePageState createState() => _PnaePageState();
}

class _PnaePageState extends State<PnaePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  List<Pnae> pnaes;
  List<Pnae> lt;

  bool _isLoading = true;

 iniciaBloc() {
    Provider.of<PnaeBloc>(context, listen: false).fetch(context).then((_) {
    setState(() {
      _isLoading = false;
    });});
  }

  @override
  void initState() {
    super.initState();
    print("y1");
    iniciaBloc();

    print("y5");
  }
  // List<PedidoItens> itens =[];

  @override
  Widget build(BuildContext context) {
     final bloc = Provider.of<PnaeBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
      lt = bloc.lista;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Novo Nivel escolar',
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
      body: _admin(lt),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }

  _admin(List<Pnae> pnae) {
    return PnaeListView(lt);
  }

  _onClickAdd() {
    setState(() {
      bloc_bloc.inPage.add(AppPages.pnaeAdd);
    });
  }

}
