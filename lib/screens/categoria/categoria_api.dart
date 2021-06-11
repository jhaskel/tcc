import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class CategoriaApi {
  static Future<List<Categoria>> get(context,) async {
    String url = "$BASE_URL/categorias";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Categoria> favoritos = list.map<Categoria>((map) =>
        Categoria.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

   static Future<List<Categoria>> getId(context,int id) async {
    String url = "$BASE_URL/categorias/id/$id";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Categoria> favoritos = list.map<Categoria>((map) =>
        Categoria.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, Categoria c) async {
    try {
      var url = "$BASE_URL/categorias";
      if (c.id != null) {
        url += "/${c.id}";      }

      print("POST > $url");
      String json = c.toJson();
      print("JSON > $json");

      var response = await (c.id == null
          ? http.post( url, body: json)
          : http.put(url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar a categoria");
    }
  }


  static Future<ApiResponse> delete(context, Categoria c) async {
    try {
      String url = "$BASE_URL/categorias/${c.id}";
      var response = await http.delete( url);

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a categoria");
  }

}
