import 'dart:html';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/usuario/usuario_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/escola_bloc.dart';
import 'package:unigran_tcc/utils/bloc/fornecedor_bloc.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';
import 'package:validadores/validadores.dart';

class UsuarioAdd extends StatefulWidget {
  final Usuario usuario;
  UsuarioAdd({this.usuario}) : super();

  @override
  _UsuarioAddState createState() => _UsuarioAddState();
}

class _UsuarioAddState extends State<UsuarioAdd> {
  Usuario get usuario => widget.usuario;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "usuario_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();


  List<UnidadeEscolar> listEscolas;
  UnidadeEscolar unidadeEscolar;



  List<Fornecedor> listFornecedores;
  Fornecedor fornecedor;
  Map<String, int> mapNivel = new Map();
  Map<int, String> mapNivel2 = new Map();

  Map<String, int> mapForn= new Map();
  Map<int, String> mapForn2 = new Map();


  var _showProgress = false;
  final tNome = TextEditingController();
  final tEmail = TextEditingController();
  final tlogin = TextEditingController();
  final tTipo = TextEditingController();
  final tNivel = TextEditingController();

  int _radioIndex = 0;

  int idEscola;
  String nomeEscola = '';

  int idFornecedor;
  String nomeFornecedor = '';
  bool _isLoading = true;
  bool buscando = true;

  getNomeNivel(String data) {
   print("KKKnivel $data");
    int jk = int.parse(data);
    if (mapNivel2.containsKey(jk)) {
      setState(() {
        idEscola = jk;
      });
      return mapNivel2[jk];
    }
  }

  getNomeFornecedor(String data) {
  print("KKKfor $data");
    int jk = int.parse(data);
    if (mapForn2.containsKey(jk)) {
      setState(() {
        idFornecedor = jk;
      });
      return mapForn2[jk];
    }
  }



   iniciaBloc() {
    Provider.of<EscolaBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
      _isLoading = false;
       for (var gh in value) {
          mapNivel.putIfAbsent(gh.nome, () => gh.id);
        }
        print("mapnivel${mapNivel}");

        for (var gh in value) {
          mapNivel2.putIfAbsent(gh.id, () => gh.nome);
        }

    });

    });

      Provider.of<FornecedorBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
      _isLoading = false;
       listFornecedores = value;
       for (var gh in listFornecedores) {
          mapForn.putIfAbsent(gh.nome, () => gh.id);        }


        for (var gh in listFornecedores) {
          mapForn2.putIfAbsent(gh.id, () => gh.nome);
        }


    });  });


  }

  @override
  void initState() {
  iniciaBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('tips$idEscola');
     print('idFor$idFornecedor');
    return _body();
  }

  _body() {
    tNivel.text = nomeEscola;
    tNivel.text = nomeFornecedor;
  //  print('tNivel${tNivel.text}');

    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaria,
                        ),
                        onPressed: () {
                          bloc_bloc.inPage.add(AppPages.usuario);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Cadastro de Usuarios", style: AppTextStyles.title),
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
                  Container(
                      child: AppTFF(
                    label: 'Email',
                    hint: 'email ',
                    controller: tEmail,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .add(Validar.EMAIL, msg: "digite um email válido!")
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                 _radioIndex==0
                 ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapNivel.keys.toList(),
                        label: "Escolas",
                        onChanged: (String data) {
                          setState(() {
                            idEscola = mapNivel[data];
                            nomeEscola = data;
                          });
                        },
                        selectedItem: unidadeEscolar == null
                            ? 'Selecione uma escola'
                            : getNomeNivel(tNivel.text)),
                  )
                  :Container(),
                  _radioIndex == 3? Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapForn.keys.toList(),
                        label: "Fornecedor",
                        onChanged: (String data) {
                          setState(() {
                            idFornecedor = mapForn[data];
                            nomeFornecedor = data;
                          });
                        },
                        selectedItem:
                             'Selecione um Fornecedor'
                            ),
                  ):Container(),
                  AppButton(
                    "Cadastrar",
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


  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return Nivel.escola;
        break;
      case 1:
        return Nivel.master;
        break;
      case 2:
        return Nivel.admin;
        break;
      case 3:
        return Nivel.fornecedor;
        break;
      case 4:
        return Nivel.publico;
        break;
      case 5:
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
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.escola,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),

        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.master,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),

        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.admin,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),

        Radio(
          value: 3,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.fornecedor,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 4,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          Role.publico,
          style: TextStyle(color: AppColors.primaria, fontSize: 14),
        ),
        Radio(
          value: 5,
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
      String senha =
          r'$2a$10$HKveMsPlst41Ie2LQgpijO691lUtZ8cLfcliAO1DD9TtZxEpaEoJe';

      // Cria o usuario
      var nivel = usuario ?? Usuario();
      nivel.nome = tNome.text;
      nivel.email = tEmail.text;
      nivel.login = tEmail.text;
      nivel.escola = _radioIndex == 0 ? idEscola : 0;
      nivel.nivel = _getTipo();
      nivel.senha = senha;
      nivel.roles = [];
      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response =
          (await UsuarioApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Usuario cadastrado com sucesso", callback: () {});
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
}
