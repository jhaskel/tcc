import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_listview.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/escola_bloc.dart';


class UnidadeEscolarPage extends StatefulWidget {
  @override
  _UnidadeEscolarPageState createState() => _UnidadeEscolarPageState();
}

class _UnidadeEscolarPageState extends State<UnidadeEscolarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Usuario get user => AppModel.get(context).user;

  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<UnidadeEscolar> unidadeEscolars;
  List<UnidadeEscolar> lt;
  bool buscando = true;
  bool _isLoading = true;

  iniciaBloc() {
    Provider.of<EscolaBloc>(context, listen: false).fetch(context).then((_) {
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
    final bloc = Provider.of<EscolaBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading){
    return Center(child: Text('Sem registros!'),);

    }else
      lt = bloc.lista;
    var itens =   0;
     var alunos =   0;
    var quant = lt.forEach((x) {
    alunos = alunos+x.alunos;
    });
    var al = lt
    .where((e) => e.nivelescolar==1)
    .where((e) => e.alunos>40)
    .map((e) => e.alunos)
    .reduce((a, b) => a+b);
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

  _admin(List<UnidadeEscolar> unidadeEscolar) {
    return UnidadeEscolarListView(lt);
  }

  _onClickAdd() {
    setState(() {
      bloc_bloc.inPage.add(AppPages.unidadeEscolarAdd);
    });
  }

  Future<void> _onRefresh() {
    return iniciaBloc();
  }

  refresh() {
    iniciaBloc();
  }

}