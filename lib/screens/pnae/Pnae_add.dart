import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/pnae/Pnae.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class PnaeAdd extends StatefulWidget {
  final Pnae pnae;
  PnaeAdd({this.pnae}) : super();

  @override
  _PnaeAddState createState() => _PnaeAddState();
}

class _PnaeAddState extends State<PnaeAdd> {
  Pnae get pnae => widget.pnae;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "pnae_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  Color cor = Colors.white;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '-##.######', filter: {"#": RegExp(r'[0-9]')});

  var _showProgress = false;

  final tValor = TextEditingController();

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
                          bloc_bloc.inPage.add(AppPages.pnae);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Cadastrar Recurso do Pnae",
                          style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Valor',
                    hint: 'Digite o valor do recurso',
                    controller: tValor,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
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

      String quant = tValor.text;
      double valor;
      if (quant.contains(',')) {
        quant = quant.replaceAll(".", "");
        quant = quant.replaceAll(",", ".");
        valor = double.parse(quant);
      } else {
        valor = double.parse(quant);
      }
      var hoje = DateTime.now().toIso8601String();
      // Cria o usuario
      var nivel = pnae ?? Pnae();
      nivel.valor = valor;

      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;

      ApiResponse<bool> response =
          (await PnaeApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Pnae cadastrado com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.pnae);
      });

      print("Fim.");
    }
  }
}
