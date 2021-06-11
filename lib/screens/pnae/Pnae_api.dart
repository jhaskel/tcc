import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/pnae/Pnae.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class PnaeApi {
  static Future<List<Pnae>> get(context,) async {
    String url = "$BASE_URL/pnae";

    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Pnae> favoritos = list.map<Pnae>((map) =>
        Pnae.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, Pnae c) async {
    try {
      var url = "$BASE_URL/pnae";
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

      return ApiResponse.error(msg: "Não foi possível salvar a pnae");
    }
  }


  static Future<ApiResponse> delete(context, Pnae c) async {
    try {
      String url = "$BASE_URL/pnae/${c.id}";

      var response = await http.delete( url);

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a pnae");
  }

}
