import 'dart:convert' as convert;

class AfAdd {
  int id;
  int code;
  int fornecedor;  
  bool isenviado;
  String status;
  bool isativo;
  String createdAt;


  AfAdd(
      {this.id,
        this.code,
        this.fornecedor,        
        this.createdAt,
        this.isenviado,
        this.status,
        this.isativo,
        

      });

  AfAdd.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    fornecedor = json['fornecedor'];   
    createdAt = json['createdAt'];
    isenviado = json['isenviado'];
    status = json['status'];
    isativo = json['isativo'];
   

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
   

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

   @override
   String toString() {
     return 'Af{id: $id,code: $code, fornecedor: $fornecedor, enviado: $isenviado}';
   }
}