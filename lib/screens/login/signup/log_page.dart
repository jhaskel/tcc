import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/login/login_form.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/main/main_screen.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/core/app_colors.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  Size get size => MediaQuery.of(context).size;

  AppModel get app => AppModel.get(context);

  @override
  void initState() {
    super.initState();
    // Login automático
    _autoLogin();
  }

  void _autoLogin() async {
    // Lê do storage
    Usuario user = await Usuario.get();

    if (user != null) {
      String yourToken = user.token;
      DateTime expirationDate = JwtDecoder.getExpirationDate(yourToken);
      bool hasExpired = JwtDecoder.isExpired(yourToken);
      // Salva no Provider
      if (!hasExpired) {
        AppModel.get(context).setUser(user);
        push(context, MainScreen(), replace: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _layoutBackgroundImg(),
    );
  }

  _layoutBackgroundImg() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          "assets/images/background.jpg",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Center(
          child: Container(
            width: 460,
            height: 500,
            decoration: BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaria,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  height: 76,
                  child: Center(
                    child: Text(
                      "Merenda Escolar",
                      style: AppTextStyles.bodyWhite20
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: _form(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _form() {
    return LoginForm();
  }
}
