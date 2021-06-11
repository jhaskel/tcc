import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';
import 'package:unigran_tcc/screens/fornecedor/fornecedor_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class FornecedorEdit extends StatefulWidget {
  final Fornecedor fornecedor;
  FornecedorEdit({this.fornecedor}) : super();

  @override
  _FornecedorEditState createState() => _FornecedorEditState();
}

class _FornecedorEditState extends State<FornecedorEdit> {
  Fornecedor get dados => widget.fornecedor;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "fornecedor_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  var _showProgress = false;

  final tNome = TextEditingController();
  final tCnpj = TextEditingController();
  final tAlias = TextEditingController();
  final tEmail = TextEditingController();
  final tCelular = TextEditingController();

  bool _isativo;

  @override
  void initState() {
    //  Copia os dados  para o form
    if (dados != null) {
      tNome.text = dados.nome;
      tAlias.text = dados.alias;
      tCnpj.text = dados.cnpj;
      tEmail.text = dados.email;
      tCelular.text = dados.celular.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      Text("Editar  Fornecedor", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da fornecedor',
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Alias',
                    hint: 'Nome Curto',
                    controller: tAlias,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'CNPJ',
                    hint: 'Nome Curto',
                    controller: tCnpj,
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
      var nivel = dados ?? Fornecedor();
      nivel.nome = tNome.text;
      nivel.alias = tAlias.text;
      nivel.cnpj = tCnpj.text;
      nivel.email = tEmail.text;
      nivel.celular = tCelular.text;
      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;
      ApiResponse<bool> response =
          (await FornecedorApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Fornecedor editada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.fornecedor);
      });

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Fornecedor c) {
    var cate = c ?? Fornecedor();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    FornecedorApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.fornecedor);
    });
  }
}
