import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/config/Config.dart';
import 'package:unigran_tcc/screens/config/Config_api.dart';

import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class ConfigEdit extends StatefulWidget {
  final Config config;
  ConfigEdit({this.config}) : super();

  @override
  _ConfigEditState createState() => _ConfigEditState();
}

class _ConfigEditState extends State<ConfigEdit> {
  Config get dados => widget.config;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "config_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  var _showProgress = false;

  final tCargo = TextEditingController();
  final tCelular = TextEditingController();
  final tEntidade = TextEditingController();
  final tEmail = TextEditingController();
  final tNomeContato = TextEditingController();
  final tSetor = TextEditingController();

  bool _isativo;

  @override
  void initState() {
    //  Copia os dados  para o form
    if (dados != null) {
      tCargo.text = dados.cargo;
      tCelular.text = dados.celular;
      tEntidade.text = dados.entidade;
      tEmail.text = dados.email;
      tNomeContato.text = dados.nomeContato;
      tSetor.text = dados.setor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isativo = dados.ativo;
    return Scaffold(
      appBar: AppBar(
        title: Text(dados.entidade),
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
                      Text("Editar  Config", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Entidade',
                    hint: 'Nome da entidade',
                    controller: tEntidade,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Setor',
                    hint: 'Nome do setor',
                    controller: tSetor,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Nome do Responsável',
                    hint: 'Responsável pelo setor',
                    controller: tNomeContato,
                  )),

                  Container(
                      child: AppTFF(
                        label: 'Cargo',
                        hint: 'cargo do responsável',
                        controller: tNomeContato,
                      )),
                  Container(
                      child: AppTFF(
                    label: 'Email',
                    hint: 'Email',
                    controller: tEmail,
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Celular',
                    hint: 'numero de celular ou telefone',
                    controller: tCelular,
                  )),
                  AppButton(
                    "Editar",
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
      var code = DateTime.now().hashCode;

      // Cria o usuario
      var nivel = dados ?? Config();
      nivel.entidade = tEntidade.text;
      nivel.setor = tSetor.text;
      nivel.nomeContato = tNomeContato.text;
      nivel.cargo = tCargo.text;
      nivel.email = tEmail.text;
      nivel.celular = tCelular.text;
      nivel.ativo = true;
      nivel.created = hoje;
      nivel.modified = hoje;
      ApiResponse<bool> response =
          (await ConfigApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Config editada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.config);
      });

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Config c) {
    var cate = c ?? Config();
    cate.ativo = newValue;
    cate.modified = DateTime.now().toIso8601String();
    ConfigApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.config);
    });
  }
}
