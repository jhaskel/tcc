import 'dart:convert' as convert;

import 'package:unigran_tcc/utils/utils.dart';

class Af {
  int id;
  int code;
  int fornecedor;
  bool isenviado;
  String status;
  bool isativo;
  String createdAt;
  //não esta no banco
  String nomefor;
  double tot;



  Af(
      {this.id,
        this.code,
        this.fornecedor,
        this.createdAt,
        this.isenviado,
        this.status,
        this.isativo,
        this.nomefor,
        this.tot

      });

  Af.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    fornecedor = json['fornecedor'];

    createdAt = json['createdAt'];
    isenviado = json['isenviado'];
    status = json['status'];
    isativo = json['isativo'];

    nomefor = json['nomefor'];
    tot = json['tot'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['fornecedor'] = this.fornecedor;
    data['createdAt'] = this.createdAt;
    data['isenviado'] = this.isenviado;
    data['isativo'] = this.isativo;
    data['status'] = this.status;
    data['tot'] = this.tot;
    data['nomefor'] = this.nomefor;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

   @override
   String toString() {
     return 'Usuariok{id: $id,code: $code, fornecedor: $Role.fornecedor, enviado: $isenviado}';
   }
}