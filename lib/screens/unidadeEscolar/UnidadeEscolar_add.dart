import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/nivel_bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dropdown_search/dropdown_search.dart';



class UnidadeEscolarAdd extends StatefulWidget {
  final UnidadeEscolar unidadeEscolar;
  UnidadeEscolarAdd({this.unidadeEscolar}) : super();
  @override
  _UnidadeEscolarAddState createState() => _UnidadeEscolarAddState();
}

class _UnidadeEscolarAddState extends State<UnidadeEscolarAdd> {
  UnidadeEscolar get unidadeEscolar => widget.unidadeEscolar;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "unidadeEscolar_form");

  Color cor = Colors.white;
  var _showProgress = false;
  final tNome = TextEditingController();
  final tNivel = TextEditingController();
  final tAlias = TextEditingController();
  final tEndereco = TextEditingController();
  final tBairro = TextEditingController();
  final tAlunos = TextEditingController();

  int idNivel;
  String nomeNivel = '';

  Map<String, int> mapNivel = new Map();
  Map<int, String> mapNivel2 = new Map();
  List<NivelEscolar> nivelEscolar;
  bool _isLoading = true;

  getNomeNivel(String data) {
    int jk = int.parse(data);
    if (mapNivel2.containsKey(jk)) {
      setState(() {
        idNivel = jk;
      });
      return mapNivel2[jk];
    }
  }

  @override
  void initState() {

   Provider.of<NivelBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
     for (var gh in value) {
          mapNivel.putIfAbsent(gh.nome, () => gh.id);
        }
        print("mapnivel${mapNivel}");

        for (var gh in value) {
          mapNivel2.putIfAbsent(gh.id, () => gh.nome);
        }
        print("mapnivel2${mapNivel2}");
      _isLoading = false;

    });});



    // Copia os dados  para o form

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
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
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaria,
                        ),
                        onPressed: () {
                          bloc_bloc.inPage.add(AppPages.unidadeEscolar);
                        },
                      ),
                      Text(
                        "Cadastro de Unidades escolares",
                        style: AppTextStyles.title,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapNivel.keys.toList(),
                        label: "Nível Escolar",
                        onChanged: (String data) {
                          setState(() {
                            idNivel = mapNivel[data];
                            nomeNivel = data;
                          });
                        },
                        selectedItem: unidadeEscolar == null
                            ? 'Selecione um nível escolar'
                            : getNomeNivel(tNivel.text)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da escola',
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Sigla',
                    hint: 'sigla da escola',
                    controller: tAlias,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Endereço',
                    hint: 'endereço da escola',
                    controller: tEndereco,
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Bairro',
                    hint: 'Bairro da escola',
                    controller: tBairro,
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Número de Alunos',
                    hint: 'quantidade de alunos da escola',
                    controller: tAlunos,
                    kType: TextInputType.number,
                  )),
                  Divider(
                    height: 5.0,
                  ),
                  AppButton(
                    "Cadastrar",
                    onPressed: _onClickSalvar,
                    showProgress: _showProgress,
                  ),
                ],
              ))),
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

      // Cria o usuario
      var nivel = unidadeEscolar ?? UnidadeEscolar();
      nivel.nome = tNome.text;
      nivel.alias = tAlias.text;
      nivel.nivelescolar = idNivel;
      nivel.endereco = tEndereco.text;
      nivel.bairro = tBairro.text;
      nivel.alunos = int.parse(tAlunos.text);
      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response = await UnidadeEscolarApi.save(context, nivel);

      if (response.ok) {
        alert(context, "UnidadeEscolar salvo com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.unidadeEscolar);
      });

      print("Fim.");
    }
  }
}
