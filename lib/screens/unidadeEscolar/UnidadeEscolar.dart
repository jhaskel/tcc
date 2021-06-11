import 'dart:convert' as convert;

class UnidadeEscolar {
  int id;
  int nivelescolar;
  String nome;
  String alias;
  String endereco;
  String bairro;
  int alunos;
  bool isativo;
  String createdAt;
  String modifiedAt;

  UnidadeEscolar(
      {this.id,
        this.nivelescolar,
        this.nome,
        this.alias,
        this.endereco,
        this.bairro,
        this.alunos,
        this.isativo,
        this.createdAt,
        this.modifiedAt});

  UnidadeEscolar.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nivelescolar = json['nivelescolar'];
    nome = json['nome'];
    alias = json['alias'];
    endereco = json['endereco'];
    bairro = json['bairro'];
    alunos = json['alunos'];
    isativo = json['isativo'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nivelescolar'] = this.nivelescolar;
    data['nome'] = this.nome;
    data['alias'] = this.alias;
    data['endereco'] = this.endereco;
    data['bairro'] = this.bairro;
    data['alunos'] = this.alunos;
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