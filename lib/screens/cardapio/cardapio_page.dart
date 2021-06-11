import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/cardapio/Cardapio.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_listview.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/cardapio_bloc.dart';
import 'package:unigran_tcc/utils/bloc/escola_bloc.dart';



class CardapioPage extends StatefulWidget {
  final Usuario user;

  CardapioPage(this.user);

  @override
  _CardapioPageState createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<Cardapio> listCardapio;
  List<UnidadeEscolar> listEscolas;
  bool buscando = true;
  bool _isLoading = true;
  bool _isLoadingEscolas = true;
  Usuario get user=>widget.user;

  iniciaBloc() {
   Provider.of<EscolaBloc>(context, listen: false).fetch(context).then((_) {
    setState(() {
      _isLoadingEscolas = false;
    });

    });
    Provider.of<CardapioBloc>(context, listen: false).fetch(context).then((_) {
    setState(() {
      _isLoading = false;
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
    final blocEscolas = Provider.of<EscolaBloc>(context);
    final bloc = Provider.of<CardapioBloc>(context);

    if (blocEscolas.lista.length == 0 && _isLoadingEscolas) {
      return Center(child: CircularProgressIndicator());
    } else if(blocEscolas.lista.length == 0 && !_isLoadingEscolas){
    return Center(child: Text('Não foi possível buscar os daddos!'),);

    }
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if(bloc.lista.length == 0 && !_isLoading ){
    return Scaffold(
      key: _scaffoldKey,

      floatingActionButton: !user.isPublico()
      ?FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Novo ìtem no Cardápio',
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ):Container(),
      body: Center(child: Text("Sem registros",style: AppTextStyles.heading40,)),
    );



    }else

      listCardapio = bloc.lista;
      listEscolas = blocEscolas.lista;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: !user.isPublico()
      ?FloatingActionButton(
        onPressed: () => _onClickAdd(),
        backgroundColor: AppColors.button,
        child: Tooltip(
          message: 'Novo ìtem no Cardápio',
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ):Container(),
      body: _admin(listCardapio,listEscolas),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
    );
  }

  _admin(List<Cardapio> cardapio, List<UnidadeEscolar> listEscolas) {
    return CardapioListView(listCardapio,listEscolas,user);
  }

  _onClickAdd() {
    setState(() {
      bloc_bloc.inPage.add(AppPages.cardapioAdd);
    });
  }



}