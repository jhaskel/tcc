import 'dart:convert' as convert;
class Pnae {
  int id;
  double valor;
  String created;
  int ano;
  bool isativo;
  String createdAt;
  String modifiedAt;


  Pnae({this.id, this.valor, this.created, this.ano,this.isativo,this.createdAt,this.modifiedAt});

  Pnae.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    valor = json['valor'];
    created = json['created'];
    ano = json['ano'];
    isativo = json['isativo'];
    modifiedAt = json['modifiedAt'];
    createdAt = json['createdAt'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valor'] = this.valor;
    data['created'] = this.created;
    data['ano'] = this.ano;
    data['isativo'] = this.isativo;
    data['modifiedAt'] = this.modifiedAt;
    data['createdAt'] = this.createdAt;

    return data;

  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Pnae{id: $id,valor: $valor, ano: $ano, created: $created}';
  }
}