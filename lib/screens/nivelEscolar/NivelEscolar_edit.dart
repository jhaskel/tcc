import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:validadores/Validador.dart';

class NivelEscolarEdit extends StatefulWidget {
  final NivelEscolar nivelEscolar;
  NivelEscolarEdit({this.nivelEscolar}) : super();

  @override
  _NivelEscolarEditState createState() => _NivelEscolarEditState();
}

class _NivelEscolarEditState extends State<NivelEscolarEdit> {
  NivelEscolar get dados => widget.nivelEscolar;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "nivelEscolar_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});
  var _showProgress = false;

  final tNome = TextEditingController();

  String cpessoa = "CPF";
  String npessoa = "Nome";
  bool _isativo;

  @override
  void initState() {
    print('XX1');
    //  Copia os dados  para o form
    if (dados != null) {
      tNome.text = dados.nome;
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
                      Text("Editar  Nivel Escolar", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Nome do Nível",
                      style: AppTextStyles.body20,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                          controller: tNome,
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: 'Campo obrigatório')
                                .maxLength(20,
                                    msg: "Campo muito grande(max:10)")
                                .valido(text, clearNoNumber: false);
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    "Salvar",
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
      var nivel = dados ?? NivelEscolar();
      nivel.nome = tNome.text;
      nivel.modifiedAt = hoje;
      nivel.isativo = _isativo;
      ApiResponse<bool> response =
          (await NivelEscolarApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "NivelEscolar editado com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.nivelEscolar);
      });

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, NivelEscolar c) {
    var cate = c ?? NivelEscolar();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    NivelEscolarApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.nivelEscolar);
    });
  }
}
