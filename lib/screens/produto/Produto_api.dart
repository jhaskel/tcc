import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class ProdutoApi {
  static Future<List<Produto>> get(context,) async {
    String url = "$BASE_URL/produtos";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Produto> favoritos = list.map<Produto>((map) =>
        Produto.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Produto>> getId(context,int id) async {
    String url = "$BASE_URL/produtos/id/$id";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Produto> favoritos = list.map<Produto>((map) =>
        Produto.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Produto>> getMenos(context) async {
    String url = "$BASE_URL/produtos/menos";
    final response = await http.get( url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Produto> favoritos = list.map<Produto>((map) =>
        Produto.fromMap(map)).toList();

    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, Produto c) async {
    try {
      var url = "$BASE_URL/produtos";
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

      return ApiResponse.error(msg: "Não foi possível salvar a produto");
    }
  }


  static Future<ApiResponse> delete(context, Produto c) async {
    try {
      String url = "$BASE_URL/produtos/${c.id}";

      var response = await http.delete( url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a produto");
  }

}
