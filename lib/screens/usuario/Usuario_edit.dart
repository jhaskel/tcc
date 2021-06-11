import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/usuario/usuario_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/escola_bloc.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class UsuarioEdit extends StatefulWidget {
  final Usuario usuario;
  UsuarioEdit({this.usuario}) : super();

  @override
  _UsuarioEditState createState() => _UsuarioEditState();
}

class _UsuarioEditState extends State<UsuarioEdit> {
  Usuario get dados => widget.usuario;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "usuario_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  List<UnidadeEscolar> nivelEscolar;
  UnidadeEscolar unidadeEscolar;
  Map<String, int> mapNivel = new Map();
  Map<int, String> mapNivel2 = new Map();

  var _showProgress = false;

  final tNome = TextEditingController();
  final tNivel = TextEditingController();
  int _radioIndex = 0;

  int idEscola;
  String nomeEscola = '';
  bool _isativo;
  bool _isLoading = true;

  getNomeNivel(String data) {
    int jk = int.parse(data);
    if (mapNivel2.containsKey(jk)) {
      setState(() {
        idEscola = jk;
      });
      return mapNivel2[jk];
    }
  }

  iniciaBloc() {
    Provider.of<EscolaBloc>(context, listen: false)
        .fetch(context)
        .then((value) {
      setState(() {
        _isLoading = false;
        nivelEscolar = value;
        for (var gh in value) {
          mapNivel.putIfAbsent(gh.nome, () => gh.id);
        }
        print("mapnivel${mapNivel}");

        for (var gh in value) {
          mapNivel2.putIfAbsent(gh.id, () => gh.nome);
        }
        print("mapnivel2${mapNivel2}");
        print("mapnivel2${mapNivel2[idEscola]}");
      });
    });
  }

  @override
  void initState() {
    idEscola = widget.usuario.escola;
    iniciaBloc();
    //  Copia os dados  para o form
    if (dados != null) {
      tNome.text = dados.nome;
      _radioIndex = getTipoInt(dados);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EscolaBloc>(context);
    if (bloc.lista.length == 0 && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bloc.lista.length == 0 && !_isLoading) {
      return Center(
        child: Text('Sem registros!'),
      );
    } else
      for (var gh in bloc.lista) {
        mapNivel.putIfAbsent(gh.nome, () => gh.id);
      }
    print("mapnivel${mapNivel}");

    for (var gh in bloc.lista) {
      mapNivel2.putIfAbsent(gh.id, () => gh.nome);
    }
    print("rd $_radioIndex");
    tNivel.text = nomeEscola;
    _isativo = dados.isativo;
    return Scaffold(
      appBar: AppBar(
        title: Text(dados.nome),
        centerTitle: true,
        actions: [
          MergeSemantics(
            child: CupertinoSwitch(
              value: _isativo,
              onChanged: (bool newValue) {
                setState(() {
                  _isativo = newValue;
                });
                alteraStatus(newValue, dados);
              },
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    //  return Container(color: Colors.green,);
    return _cardForm();
  }

  _cardForm() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Editar  Usuario", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      "Nível",
//              textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaria,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _radioTipo(),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da usuario',
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapNivel.keys.toList(),
                        label: "Nível Escolar",
                        onChanged: (String data) {
                          setState(() {
                            idEscola = mapNivel[data];
                            nomeEscola = data;
                          });
                        },
                        selectedItem: mapNivel2[idEscola]),
                  ),
                  AppButton(
                    "Editar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
    );
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Usuario usuario) {
    switch (usuario.nivel) {
      case '0':
        return 0;
      case "1":
        return 1;
      case "2":
        return 2;
      case "3":
        return 3;
      case "4":
        return 4;
      case "5":
        return 5;
      case "6":
        return 6;
        case "7":
        return 7;
      default:
        return 0;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 1:
        return Nivel.dev;
        break;
      case 2:
        return Nivel.master;
        break;
      case 3:
        return Nivel.admin;
        break;
      case 4:
        return Nivel.escola;
        break;
      case 5:
        return Nivel.fornecedor;
        break;
      case 6:
        return Nivel.publico;
        break;
      case 7:
        return Nivel.nutrucionista;
        break;
      default:
        0;
    }
  }

  _radioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.dev,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.master,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 3,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.admin,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 4,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.escola,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 5,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.fornecedor,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 6,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.publico,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 7,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.nutrucionista,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
      ],
    );
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();
      var code = DateTime.now().hashCode;

      // edita o usuario
      var nivel = dados ?? Usuario();
      nivel.nome = tNome.text;
      nivel.escola = idEscola;
      nivel.nivel = _getTipo();
      nivel.isativo = true;
      nivel.modifiedAt = hoje;
      ApiResponse<bool> response =
          (await UsuarioApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Usuario editada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.usuario);
      });

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Usuario c) {
    var cate = c ?? Usuario();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    UsuarioApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.usuario);
    });
  }
}
