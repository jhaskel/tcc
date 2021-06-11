import 'dart:async';
import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/login/api_response.dart';
import 'package:unigran_tcc/screens/login/login_api.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/utils/bloc.dart';
import 'package:unigran_tcc/utils/app_model.dart';

class LoginInput {
  String login;
  String senha;
  bool checkManterLogado = false;

  String toJson() {
    return convert.json.encode({
      "username": login,
      "password": senha,
    });
  }
}

class LoginBloc {
  final checkManterLogado = BooleanBloc();
  final progress = BooleanBloc();

  Future<ApiResponse<Usuario>> login(context, LoginInput loginInput) async {
    progress.set(true);

    ApiResponse<Usuario> response = await LoginApi.login(loginInput);

    if (response.ok) {
      Usuario user = response.result;

      if (loginInput.checkManterLogado) {
        // Somente salva nas prefs se marcou o checkbox
        user.save();
      }
      user.save();
      print("User API $user");

      // Salva no app model
      AppModel app = AppModel.get(context);
      app.setUser(user);
    }

    progress.set(false);

    return response;
  }

  void dispose() {
    progress.dispose();
    checkManterLogado.dispose();
  }
}
