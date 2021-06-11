import 'dart:convert' as convert;

class NivelEscolar {
  int id;
  String nome;
  bool isativo;
  String createdAt;
  String modifiedAt;

  NivelEscolar({this.id, this.nome, this.isativo, this.createdAt, this.modifiedAt});

  NivelEscolar.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    isativo = json['isativo'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['isativo'] = this.isativo;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    return data;
  }


  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Usuariok{id: $id,nome: $nome, fantasia: $nome, cpf: $id}';
   }
}