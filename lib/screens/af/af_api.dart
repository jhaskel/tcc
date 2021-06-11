import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/af/Af.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class AfApi {
  static Future<List<Af>> get(
    context,
  ) async {
    String url = "$BASE_URL/af";
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) => Af.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Af>> getFornecedor(context, int fornecedor) async {
    String url = "$BASE_URL/af/fornecedor/$fornecedor";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) => Af.fromMap(map)).toList();
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Af c) async {
    try {
      var url = "$BASE_URL/af";
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
      return ApiResponse.error(msg: "Não foi possível salvar a af");
    }
  }

  static Future<ApiResponse> delete(context, Af c) async {
    try {
      String url = "$BASE_URL/af/${c.id}";
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        return ApiResponse.ok(id: 1);
      }
    } catch (e) {}
    return ApiResponse.error(msg: "Não foi possível deletar a af");
  }
}
