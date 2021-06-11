import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/usuario_bloc.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  final BlocController bloc = BlocProvider.getBloc<BlocController>();

  List<Usuario> usuarios;
  List<Usuario> lt;
  bool _isLoading = true;

iniciaBloc() {
    Provider.of<UsuarioBloc>(context, listen: false).fetch(context).then((_) {
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
    final bloc = Provider.of<UsuarioBloc>(context);
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

  _admin(List<Usuario> usuario) {
    return UsuarioListView(lt);
  }

  _onClickAdd() {
    setState(() {
      bloc.inPage.add(AppPages.usuarioAdd);
    });
  }


}
