import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:unigran_tcc/utils/http_helper.dart' as http;

class PedidoItensApi {
  static Future<List<PedidoItens>> getByAf(context, int af) async {
    String url = "$BASE_URL/itens/af/$af";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByTotalMes(context, int ano) async {
    String url = "$BASE_URL/itens/totalMes/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByTotalCategoria(context, int ano) async {
    String url = "$BASE_URL/itens/totalCategoria/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByTotalEscola(context, int ano) async {
    String url = "$BASE_URL/itens/totalEscolas/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByMediaAlunos(context, int ano) async {
    String url = "$BASE_URL/itens/mediaAlunos/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByTotalMesEscola(
      context, int escola, int ano) async {
    String url = "$BASE_URL/itens/totalMesEscola/$escola/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByTotalCategoriaEscola(
      context, int escola, int ano) async {
    String url = "$BASE_URL/itens/totalCategoriaEscola/$escola/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getMaisPedido(context, int ano) async {
    String url = "$BASE_URL/itens/maispedidos/$ano";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
        list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getByAfi(context) async {
    String url = "$BASE_URL/itens/afi";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getPed(context, int pedido) async {
    String url = "$BASE_URL/itens/pedido/$pedido";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

   static Future<List<PedidoItens>> getProduto(context, int produto) async {
    String url = "$BASE_URL/itens/produto/$produto";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getProduto2(context, int produto) async {
    String url = "$BASE_URL/itens/produto2/$produto";
    final response = await http.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, PedidoItens c) async {
    try {
      var url = "$BASE_URL/itens";
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
      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }

  static Future<ApiResponse<bool>> delete(context, PedidoItens c) async {
    try {
      String url = "$BASE_URL/itens/${c.id}";
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        return ApiResponse.ok();
      }
      return ApiResponse.error(msg: "Não foi possível deletar o brique");
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível deletar o brique");
    }
  }
}
