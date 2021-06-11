import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:validadores/Validador.dart';

class NivelEscolarAdd extends StatefulWidget {
  final NivelEscolar nivelEscolar;
  NivelEscolarAdd({this.nivelEscolar}) : super();

  @override
  _NivelEscolarAddState createState() => _NivelEscolarAddState();
}

class _NivelEscolarAddState extends State<NivelEscolarAdd> {
  NivelEscolar get nivelEscolar => widget.nivelEscolar;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "nivelEscolar_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tNome = TextEditingController();
  bool JSVal = true;
  bool tipo = true;
  String cpessoa = "CPF";
  String npessoa = "Nome";
  bool uploading = false;

  @override
  void initState() {
    print('XX1');
    // Copia os dados  para o form
    //   if (nivelEscolar != null) {
    //     tNome.text = nivelEscolar.nome;
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
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
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaria,
                        ),
                        onPressed: () {
                          bloc_bloc.inPage.add(AppPages.nivelEscolar);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Cadastro de Nivel Escolar",
                          style: AppTextStyles.title),
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
                                .maxLength(10,
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

      // Cria o usuario
      var nivel = nivelEscolar ?? NivelEscolar();
      nivel.nome = tNome.text;
      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response =
          (await NivelEscolarApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "NivelEscolar cadastrado com sucesso", callback: () {});
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
}
