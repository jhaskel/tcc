import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/config/Config.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class ConfigApi {
  static Future<List<Config>> get(context,) async {
    String url = "$BASE_URL/config";
    final response = await http.get(url);
    print(url);
    String json = response.body;
    print(json);
    List list = convert.json.decode(json);
    List<Config> favoritos = list.map<Config>((map) =>
        Config.fromMap(map)).toList();

    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, Config c) async {
    try {
      var url = "$BASE_URL/config";
      if (c.id != null) {
        url += "/${c.id}";
      }

      String json = c.toJson();

      var response = await (c.id == null
          ? http.post( url, body: json)
          : http.put(url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {


      return ApiResponse.error(msg: "Não foi possível salvar a config");
    }
  }


  static Future<ApiResponse> delete(context, Config c) async {
    try {
      String url = "$BASE_URL/config/${c.id}";

      var response = await http.delete( url);

          if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a config");
  }

}
