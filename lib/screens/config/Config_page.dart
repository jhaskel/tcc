
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/config/Config.dart';
import 'package:unigran_tcc/screens/config/Config_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/config_bloc.dart';

class ConfigPage extends StatefulWidget {


  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  List<Config> lt;
  bool _isLoading = true;

   iniciaBloc() {
    Provider.of<ConfigBloc>(context, listen: false).fetch(context).then((_) {
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

    final bloc = Provider.of<ConfigBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
    lt = bloc.lista;
      return
           Scaffold(
            key: _scaffoldKey,
            body: _admin(lt),
            drawer: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: SideMenu(),
            ),
          );

  }

  _admin(List<Config> config) {

    return  ConfigListView(lt);
  }



}

