
import 'dart:convert' as convert;


class Categoria {
  int id;
  String nome;
  bool isativo;
  bool isalimento;
  String createdAt;
  String modifiedAt;


  Categoria({this.id, this.nome,this.isativo,this.isalimento,this.createdAt,this.modifiedAt});

  Categoria.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    isativo = json['isativo'];
    isalimento = json['isalimento'];
    modifiedAt = json['modifiedAt'];
    createdAt = json['createdAt'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['isativo'] = this.isativo;
    data['isalimento'] = this.isalimento;
    data['modifiedAt'] = this.modifiedAt;
    data['createdAt'] = this.createdAt;

    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $nome}';
  }
}