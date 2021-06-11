import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class UnidadeEscolarApi {
  static Future<List<UnidadeEscolar>> get(context) async {
    String url = "$BASE_URL/escolas";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<UnidadeEscolar> favoritos =
        list.map<UnidadeEscolar>((map) => UnidadeEscolar.fromMap(map)).toList();

    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, UnidadeEscolar c) async {
    try {
      var url = "$BASE_URL/escolas";
      if (c.id != null) {
        url += "/${c.id}";
      }
      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));



      if (response.statusCode == 200 || response.statusCode == 201) {


        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {


      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }

  static Future<ApiResponse> delete(context, UnidadeEscolar c) async {
    try {
      String url = "$BASE_URL/escolas/${c.id}";



      var response = await http.delete(url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar o empreendimento");
  }
}
