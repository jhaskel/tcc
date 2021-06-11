import 'dart:convert' as convert;
class Pedido {
  int id;
  int escola;
  double total;
  String status;
  bool isaf;
  String createdAt;
  String modifiedAt;
  bool isativo;

//não tem campo no banco
  String nomedaescola;
  

  Pedido(
      {this.id,
        this.escola,
        this.total,
        this.status,
        this.isaf,
        this.createdAt,
        this.modifiedAt,
        this.isativo,
        this.nomedaescola,
      });

  Pedido.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    escola = json['escola'];
    total = json['total'];
    status = json['status'];
    nomedaescola = json['nomedaescola'];
    isaf = json['isaf'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
    isativo = json['isativo'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['escola'] = this.escola;
    data['total'] = this.total;
    data['status'] = this.status;
    data['nomedaescola'] = this.nomedaescola;
    data['isaf'] = this.isaf;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['isativo'] = this.isativo;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,escola: $escola, produto: $escola, unidade: $id}';
  }
}