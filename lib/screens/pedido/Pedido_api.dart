import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/pedido/Pedido.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class PedidoApi {
  static Future<List<Pedido>> get(context,) async {
    String url = "$BASE_URL/pedidos";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<List<Pedido>> getEscola(context,int escola) async {
    String url = "$BASE_URL/pedidos/escola/$escola";
    print("GET2 > $url");
    final response = await http.get( url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Pedido c) async {
    try {
      var url = "$BASE_URL/pedidos";
      if (c.id != null) {
        url += "/${c.id}";     }
      String json = c.toJson();
      var response = await (c.id == null
          ? http.post( url, body: json)
          : http.put(url, body: json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);
        Pedido pedido = Pedido.fromMap(mapResponse);
        return ApiResponse.ok(id: pedido.id);
      }
      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a pedido");
    }
  }


  static Future<ApiResponse> delete(context, Pedido c) async {
    try {
      String url = "$BASE_URL/pedidos/${c.id}";
      var response = await http.delete( url);
      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {
    }
    return ApiResponse.error(msg: "Não foi possível deletar a pedido");
  }

}
