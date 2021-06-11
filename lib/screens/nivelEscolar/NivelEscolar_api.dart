import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class NivelEscolarApi {
  static Future<List<NivelEscolar>> get(context,) async {
    String url = "$BASE_URL/nivel";
    print("GET2 > $url");
    final response = await http.get(url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<NivelEscolar> favoritos = list.map<NivelEscolar>((map) =>
        NivelEscolar.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, NivelEscolar c) async {
    try {
      var url = "$BASE_URL/nivel";
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


      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse> delete(context, NivelEscolar c) async {
    try {
      String url = "$BASE_URL/nivel/${c.id}";


      var response = await http.delete( url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar o nivel escolar");
  }

}
