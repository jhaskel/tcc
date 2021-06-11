import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/comprar/Compras.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class ComprasApi {
  static Future<List<Compras>> getPed(context, int pedido) async {
    String url = "$BASE_URL/compras/pedido/$pedido";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Compras> favoritos =
        list.map<Compras>((map) => Compras.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Compras>> getByCart(context, String pedido) async {
    String url = "$BASE_URL/compras/cart/$pedido";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Compras> favoritos =
        list.map<Compras>((map) => Compras.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Compras c) async {
    try {
      var url = "$BASE_URL/compras";
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
      return ApiResponse.error(msg: "Não foi possível salvar a compras");
    }
  }

  static Future<ApiResponse> delete(context, Compras c) async {
    try {
      String url = "$BASE_URL/compras/${c.id}";
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {}
    return ApiResponse.error(msg: "Não foi possível deletar a compras");
  }
}
