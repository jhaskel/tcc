import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/cart/Cart.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class CartApi {
  static Future<List<Cart>> get(
    context,
  ) async {
    String url = "$BASE_URL/cart";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Cart>> getId(context, int id) async {
    String url = "$BASE_URL/cart/id/$id";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Cart>> getEscola(context, int escola) async {
    String url = "$BASE_URL/cart/escola/$escola";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Cart c) async {
    try {
      var url = "$BASE_URL/cart";

      if (c.id != null) {
        url += "/${c.id}";
      }

      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);
        Cart cart = Cart.fromMap(mapResponse);
        return ApiResponse.ok(id: cart.id);
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a cart");
    }
  }

  static Future<ApiResponse<bool>> update(context, Cart c) async {
    try {
      var url = "$BASE_URL/cart/${c.id}";
      String json = c.toJson();

      var response = await (http.put(url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a cart");
    }
  }

  static Future<ApiResponse> delete(context, Cart c) async {
    try {
      String url = "$BASE_URL/cart/${c.id}";

      var response = await http.delete(url);

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        Cart cart = Cart.fromMap(mapResponse);
        return ApiResponse.ok(msg: mapResponse["msg"], id: cart.id);
      }
    } catch (e) {}

    return ApiResponse.error(msg: "Não foi possível deletar a cart");
  }
}
