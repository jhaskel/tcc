import 'dart:convert' as convert;

class Cart {
  int id;
  int escola;
  int produto;
  int categoria;
  int fornecedor;
  String alias;
  String unidade;
  String cod;
  double quantidade;
  double valor;
  double total;
  String createdAt;


  Cart(
      {this.id,
        this.escola,
        this.produto,
        this.categoria,
        this.fornecedor,
        this.alias,
        this.unidade,
        this.cod,
        this.quantidade,
        this.valor,
        this.total,
        this.createdAt,
      });

  Cart.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    escola = json['escola'];
    produto = json['produto'];
    categoria = json['categoria'];
    fornecedor = json['fornecedor'];
    unidade = json['unidade'];
    cod = json['cod'];
    alias = json['alias'];
    quantidade = json['quantidade'];
    valor = json['valor'];
    total = json['total'];
    createdAt = json['created'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['escola'] = this.escola;
    data['produto'] = this.produto;
    data['categoria'] = this.categoria;
    data['fornecedor'] = this.fornecedor;
    data['unidade'] = this.unidade;
    data['cod'] = this.cod;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    data['total'] = this.total;
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
    return 'Usuariok{id: $id,escola: $escola, produto: $produto, unidade: $id}';
  }
}