import 'dart:convert' as convert;

class AfPedido {
  int id;
  int af;
  int pedido;
  double total;
  int fornecedor;

  AfPedido(
      {this.id,
        this.af,
        this.pedido,
        this.total,
        this.fornecedor,
      });

  AfPedido.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    af = json['af'];
    fornecedor = json['fornecedor'];

    pedido = json['pedido'];
    total = json['total'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['af'] = this.af;
    data['fornecedor'] = this.fornecedor;
    data['pedido'] = this.pedido;
    data['total'] = this.total;
    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }



   @override
   String toString() {
     return 'afPedido{id: $id,af: $af, pedido: $pedido}';
   }
}