import 'dart:convert' as convert;
class PedidoItens {
  int id;
  int escola;
  int produto;
  int pedido;
  String alias;
  String unidade;
  int categoria;
  int fornecedor;
  int af;
  int ano;
  double quantidade;
  double valor;
  double total;
  String status;
  String mes;
  String createdAt;
  String modifiedAt;
  bool isativo;
  //não esta no bnco
  double tot;
  String nomec;

  PedidoItens(
      {this.id,
        this.pedido,
        this.produto,
        this.escola,
        this.alias,
        this.quantidade,
        this.valor,
        this.total,
        this.af,
        this.categoria,
        this.fornecedor,
        this.createdAt,
        this.ano,
        this.unidade,
        this.status,
        this.mes,
        this.isativo,

        this.tot,
        this.nomec,
      });

  PedidoItens.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    pedido = json['pedido'];
    produto = json['produto'];
    escola = json['escola'];
    alias = json['alias'];
    quantidade = json['quantidade'];
    valor = json['valor'];
    total = json['total'];
    af = json['af'];
    createdAt = json['createdAt'];
    fornecedor = json['fornecedor'];
    categoria = json['categoria'];
    ano = json['ano'];
    unidade = json['unidade'];
    status = json['status'];
    mes = json['mes'];
    isativo = json['isativo'];
    tot = json['tot'];
    nomec = json['nomec'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['pedido'] = this.pedido;
    data['produto'] = this.produto;
    data['escola'] = this.escola;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    data['total'] = this.total;
    data['af'] = this.af;
    data['createdAt'] = this.createdAt;
    data['fornecedor'] = this.fornecedor;
    data['categoria'] = this.categoria;
    data['ano'] = this.ano;
    data['unidade'] = this.unidade;
    data['status'] = this.status;
    data['mes'] = this.mes;
    data['isativo'] = this.isativo;
    data['tot'] = this.tot;
    data['nomec'] = this.nomec;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Usuariok{id: $id,escola: $escola, categoria: $categoria, produto: $produto,pedido$pedido}';
   }
}