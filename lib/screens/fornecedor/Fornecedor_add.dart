import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unigran_tcc/core/app_colors.dart';
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

class FornecedorAdd extends StatefulWidget {
  final Fornecedor fornecedor;
  FornecedorAdd({this.fornecedor}) : super();

  @override
  _FornecedorAddState createState() => _FornecedorAddState();
}

class _FornecedorAddState extends State<FornecedorAdd> {
  Fornecedor get fornecedor => widget.fornecedor;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "fornecedor_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tNome = TextEditingController();
  final tCnpj = TextEditingController();
  final tAlias = TextEditingController();
  final tEmail = TextEditingController();
  final tCelular = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
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
                          bloc_bloc.inPage.add(AppPages.fornecedor);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Cadastro de Fornecedors",
                          style: AppTextStyles.title),
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
      var nivel = fornecedor ?? Fornecedor();
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
        alert(context, "Fornecedor cadastrado com sucesso", callback: () {});
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
}
