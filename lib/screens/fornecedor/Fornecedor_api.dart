import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class FornecedorApi {
  static Future<List<Fornecedor>> get(context,) async {
    String url = "$BASE_URL/fornecedor";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Fornecedor> favoritos = list.map<Fornecedor>((map) =>
        Fornecedor.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Fornecedor>> getId(context,int id) async {
    String url = "$BASE_URL/fornecedor/id/$id";
    print("GET2 > $url");
    final response = await http.get( url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Fornecedor> favoritos = list.map<Fornecedor>((map) =>
        Fornecedor.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Fornecedor c) async {
    try {
      var url = "$BASE_URL/fornecedor";
      if (c.id != null) {
        url += "/${c.id}";
      }

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");


      var response = await (c.id == null
          ? http.post( url, body: json)
          : http.put(url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Fornecedor empreendimento = Fornecedor.fromMap(mapResponse);

        print("Fornecedor salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar a fornecedor");
    }
  }


  static Future<ApiResponse> delete(context, Fornecedor c) async {
    try {
      String url = "$BASE_URL/fornecedor/${c.id}";

      print("DELETE > $url");

      var response = await http.delete( url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {
      print(e);
    }

    return ApiResponse.error(msg: "Não foi possível deletar a fornecedor");
  }

}
