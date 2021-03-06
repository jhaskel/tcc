import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class PedidoAddApi {
  static Future<ApiResponse<bool>> save(context, PedidoAdd c) async {
    try {
      var url = "$BASE_URL/pedidoAdd";
      if (c.id != null) {
        url += "/${c.id}";     }

      String json = c.toJson();

      print("JSON > $json");

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));


      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        PedidoAdd pedidoAdd = PedidoAdd.fromMap(mapResponse);

        return ApiResponse.ok(id: pedidoAdd.id);
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {


      return ApiResponse.error(msg: "Não foi possível salvar a pedidoAdd");
    }
  }

  static Future<ApiResponse> delete(context, PedidoAdd c) async {
    try {
      String url = "$BASE_URL/pedidoAdd/${c.id}";


      var response = await http.delete(url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a pedidoAdd");
  }
}
