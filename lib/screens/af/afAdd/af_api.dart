import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/af/afAdd/Af.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class AfAddApi {

  static Future<ApiResponse<bool>> save(context, AfAdd c) async {
    try {
      var url = "$BASE_URL/afAdd";
      if (c.id != null) {
        url += "/${c.id}";
      }
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
          return ApiResponse.error(msg: "Não foi possível salvar a af");
    }
  }
  static Future<ApiResponse> delete(context, AfAdd c) async {
    try {
      String url = "$BASE_URL/afAdd/${c.id}";

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

    return ApiResponse.error(msg: "Não foi possível deletar a af");
  }

}
