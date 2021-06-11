import 'dart:convert' as convert;
import 'package:unigran_tcc/screens/login/login_page.dart';
import 'package:unigran_tcc/utils/app_model.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/utils/prefs.dart';
import 'package:unigran_tcc/utils/utils.dart';

// global
void logout(context) {
  Usuario.clear();
  //Prefs.prefs.clear();
  AppModel.get(context).setUser(null);

  push(context, LoginPage(), replace: true);

  PagesModel.get(context).popAll();
}

class Usuario {
  int id;
  String nome;
  String email;
  String login;
  String senha;
  int escola;
  String nivel;
  bool isativo;
  String createdAt;
  String modifiedAt;
  String token;
  List<String> roles;
  bool selected = false;

  Usuario(
      {this.id,
      this.login,
      this.nome,
      this.email,
      this.senha,
      this.token,
      this.nivel,
      this.escola,
      this.isativo,
      this.createdAt,
      this.modifiedAt,
      this.roles});

  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    login = map['login'];
    nome = map['nome'];
    email = map['email'];
    senha = map['senha'];
    token = map['token'];
    nivel = map['nivel'];
    escola = map['escola'];
    isativo = map['isativo'];
    modifiedAt = map['modifiedAt'];
    createdAt = map['createdAt'];

    roles = map['roles'] != null ? map['roles'].cast<String>() : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['nivel'] = this.nivel;
    data['escola'] = this.escola;
    data['token'] = this.token;
    data['roles'] = this.roles;
    data['isativo'] = this.isativo;
    data['modifiedAt'] = this.modifiedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  void save() {
    Prefs.setString("user.prefs", toJson());
  }

  static Future<Usuario> get() async {
    String json = Prefs.getString("user.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Usuario user = Usuario.fromMap(map);
    return user;
  }

  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  bool isAdmin() {
    return nivel != null && nivel.contains(Nivel.admin);
  }


  bool isEscola() {
    return nivel != null && nivel.contains(Nivel.escola);
  }

  bool isMaster() {
    return nivel != null && nivel.contains(Nivel.master);
  }

  bool isFornecedor() {
    return nivel != null && nivel.contains(Nivel.fornecedor);
  }

  bool isDev() {
    return nivel != null && nivel.contains(Nivel.dev);
  }

   bool isPublico() {
    return nivel != null && nivel.contains(Nivel.publico);
  }

  @override
  String toString() {
    return 'Usuario{login: $login, nome: $nome, escola: $escola}';
  }
}
