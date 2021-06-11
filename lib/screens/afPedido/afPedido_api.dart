import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/afPedido/AfPedido.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class AfPedidoApi {

  static Future<ApiResponse<bool>> save(context, AfPedido c) async {
    try {
      var url = "$BASE_URL/afpedido";
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
      return ApiResponse.error(msg: "Não foi possível salvar a afPedido");
    }
  }

  }
