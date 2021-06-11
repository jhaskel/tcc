import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/main/home.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';
import 'package:unigran_tcc/utils/bloc/bloc_produto.dart';
import 'package:unigran_tcc/utils/bloc/cardapio_bloc.dart';
import 'package:unigran_tcc/utils/bloc/cart_bloc.dart';
import 'package:unigran_tcc/utils/bloc/categoria_bloc.dart';
import 'package:unigran_tcc/utils/bloc/config_bloc.dart';
import 'package:unigran_tcc/utils/bloc/escola_bloc.dart';
import 'package:unigran_tcc/utils/bloc/fornecedor_bloc.dart';
import 'package:unigran_tcc/utils/bloc/nivel_bloc.dart';
import 'package:unigran_tcc/utils/bloc/pnae_bloc.dart';
import 'package:unigran_tcc/utils/bloc/usuario_bloc.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("X2");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PagesModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => EscolaBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardapioBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => FornecedorBloc(),
        ),
         ChangeNotifierProvider(
          create: (context) => NivelBloc(),
        ),
         ChangeNotifierProvider(
          create: (context) => CategoriaBloc(),
        ),
         ChangeNotifierProvider(
          create: (context) => PnaeBloc(),
        ),
       ChangeNotifierProvider(
          create: (context) => ConfigBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsuarioBloc(),
        ),



      ],
      child: BlocProvider(
          blocs: [
            Bloc((i) => BlocController()),
            Bloc((i) => BlocProduto()),
            Bloc((i) => BlocPedido()),
            Bloc((i) => BlocAf()),

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(),
            theme: ThemeData(
                primaryColor: AppColors.primaria,
                accentColor: AppColors.secundaria),
          )),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.apartment_outlined,
          size: MediaQuery.of(context).size.width * 0.785,
        ),
      ),
    );
  }
}
