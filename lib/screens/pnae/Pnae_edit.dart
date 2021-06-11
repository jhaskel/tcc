import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class PnaeEdit extends StatefulWidget {
  final Pnae pnae;
  PnaeEdit({this.pnae}) : super();

  @override
  _PnaeEditState createState() => _PnaeEditState();
}

class _PnaeEditState extends State<PnaeEdit> {
  Pnae get dados => widget.pnae;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "pnae_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  var _showProgress = false;

  final tValor = TextEditingController();

  bool _isativo;

  @override
  void initState() {
    //  Copia os dados  para o form
    if (dados != null) {
      tValor.text = dados.valor.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isativo = dados.isativo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos do Pnae'),
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
                      Text("Editar Recurso do Pnae",
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
      String quant = tValor.text;
      double valor;
      if (quant.contains(',')) {
        quant = quant.replaceAll(".", "");
        quant = quant.replaceAll(",", ".");
        valor = double.parse(quant);
      } else {
        valor = double.parse(quant);
      }

      // Cria o usuario
      var nivel = dados ?? Pnae();
      nivel.valor = valor;

      nivel.isativo = true;
      nivel.createdAt = hoje;
      nivel.modifiedAt = hoje;
      ApiResponse<bool> response =
          (await PnaeApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Pnae editada com sucesso", callback: () {});
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

  void alteraStatus(bool newValue, Pnae c) {
    var cate = c ?? Pnae();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    PnaeApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.pnae);
    });
  }
}
