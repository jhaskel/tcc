import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unigran_tcc/screens/login/api_response.dart';
import 'package:unigran_tcc/screens/login/login_bloc.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/utils/constants.dart';

class LoginApi {
  static Future<ApiResponse<Usuario>> login(LoginInput input) async {
    try {
      var url = '$BASE_URL/login';
      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = input.toJson();
      print(">> $body");

      var response = await http.post(url, body: body, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromMap(mapResponse);

        return ApiResponse.ok(user);
      }

      return ApiResponse.error('Não foi possível salvar o usuário!');
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error("Não foi possível fazer o login.");
    }
  }
}
