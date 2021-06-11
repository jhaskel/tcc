import 'dart:convert' as convert;

import 'package:unigran_tcc/utils/prefs.dart';


class Produto {
  int id;
  int categoria;
  int fornecedor;
  String code;
  String nome;
  String alias;
  double quantidade;
  double estoque;
  double valor;
  String unidade;
  String image;
  bool agrofamiliar;

  int ano;
  bool isativo;
  String createdAt;
  String modifiedAt;
  String processo;

  Produto(
      {this.id,
        this.categoria,
        this.fornecedor,
        this.code,
        this.nome,
        this.alias,
        this.quantidade,
        this.estoque,
        this.valor,
        this.unidade,
        this.image,
        this.agrofamiliar,
        this.ano,
        this.isativo,
        this.createdAt,
        this.modifiedAt,
        this.processo
      });

  Produto.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    categoria = json['categoria'];
    fornecedor = json['fornecedor'];
    code = json['code'];
    nome = json['nome'];
    alias = json['alias'];
    quantidade = json['quantidade'];
    estoque = json['estoque'];
    valor = json['valor'];
    unidade = json['unidade'];
    image = json['image'];
    agrofamiliar = json['agrofamiliar'];
    ano = json['ano'];
    isativo = json['isativo'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
    processo = json['processo'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoria'] = this.categoria;
    data['fornecedor'] = this.fornecedor;
    data['code'] = this.code;
    data['nome'] = this.nome;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['estoque'] = this.estoque;
    data['valor'] = this.valor;
    data['unidade'] = this.unidade;
    data['image'] = this.image;
    data['agrofamiliar'] = this.agrofamiliar;
    data['ano'] = this.ano;
    data['isativo'] = this.isativo;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['processo'] = this.processo;
    return data;
  }

  static void clear() {
    Prefs.setString("pro.prefs", "");
  }

  void save() {
    Prefs.setString("pro.prefs", toJson());
  }

  static Future<Produto> get() async {
    String json = Prefs.getString("pro.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Produto pro = Produto.fromMap(map);
    return pro;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $nome, fantasia: $nome, unidade: $id}';
  }
}