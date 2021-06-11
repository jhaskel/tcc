import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/nivel_bloc.dart';


class NivelEscolarPage extends StatefulWidget {
  @override
  _NivelEscolarPageState createState() => _NivelEscolarPageState();
}

class _NivelEscolarPageState extends State<NivelEscolarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<NivelEscolar> nivelEscolars;
  List<NivelEscolar> lt;
  bool _isLoading = true;

  iniciaBloc() {
 Provider.of<NivelBloc>(context, listen: false).fetch(context).then((_) {
    setState(() {
      _isLoading = false;
    });});
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
      body: _body(),


      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }
  _body(){

  final bloc = Provider.of<NivelBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
      lt = bloc.lista;
              return _admin(lt);

  }

   _admin(List<NivelEscolar> nivelEscolar) {
    return NivelEscolarListView(lt);
  }

  _onClickAdd() {
    setState(() {
      bloc_bloc.inPage.add(AppPages.nivelEscolarAdd);
    });
  }



}
