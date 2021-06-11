import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;

class UsuarioApi {
  static Future<List<Usuario>> get(
    context,
  ) async {
    String url = "$BASE_URL/users";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Usuario> favoritos =
        list.map<Usuario>((map) => Usuario.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Usuario>> getId(context, int id) async {
    String url = "$BASE_URL/users/id/$id";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Usuario> favoritos =
        list.map<Usuario>((map) => Usuario.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Usuario c) async {
    try {
      var url = "$BASE_URL/users";
      if (c.id != null) {
        url += "/${c.id}";      }

      Map<String, String> headers = {"Content-Type": "application/json"};

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Usuario empreendimento = Usuario.fromMap(mapResponse);

        print("Usuario salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar a usuario");
    }
  }

  static Future<ApiResponse<bool>> save2(context, Usuario c) async {
    try {
      var url = "$BASE_URL/users";
      if (c.id != null) {
        url += "/${c.id}";
      }

      Map<String, String> headers = {"Content-Type": "application/json"};

      print("POST > $url");
      String json = c.toJson();
      print("JSON > $json");
      var response = await (c.id == null
          ? htttp.post(url, body: json,headers: headers)
          : htttp.put(url, body: json,headers: headers));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Usuario empreendimento = Usuario.fromMap(mapResponse);

        print("Usuario salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar a usuario");
    }
  }


  static Future<ApiResponse> delete(context, Usuario c) async {
    try {
      String url = "$BASE_URL/users/${c.id}";

      print("DELETE > $url");

      var response = await http.delete(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {
      print(e);
    }

    return ApiResponse.error(msg: "Não foi possível deletar a usuario");
  }
}
