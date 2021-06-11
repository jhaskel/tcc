import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/screens/login/login_page.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/main/main_screen.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // Inicializar o banco de dados

    Future futureB = Future.delayed(Duration(seconds: 3));

    // Usuario
    Future<Usuario> futureC = Usuario.get();
    Future.wait([futureB, futureC]).then((List values) {
      Usuario user = values[1];
      print('spl ${user}');
      if (user != null) {
        print('spl0 ${user}');
        push(
            context,
            MainScreen(
              user: user,
            ),
            replace: true);
      } else {
        push(context, LoginPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('splash');
    return Container(
      color: AppColors.primaria,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
