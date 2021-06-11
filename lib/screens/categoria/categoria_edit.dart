import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/categoria/categoria_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class CategoriaEdit extends StatefulWidget {
  final Categoria categoria;
  CategoriaEdit({this.categoria}) : super();

  @override
  _CategoriaEditState createState() => _CategoriaEditState();
}

class _CategoriaEditState extends State<CategoriaEdit> {
  Categoria get dados => widget.categoria;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "categoria_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  var _showProgress = false;

  final tNome = TextEditingController();


  bool _isativo;

  @override
  void initState() {
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
                      Text("Editar  Categoria", style: AppTextStyles.title),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Nome',
                    hint: 'Nome da categoria',
                    controller: tNome,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),

                  SizedBox(
                    height: 20,
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
      var nivel = dados ?? Categoria();
      nivel.nome = tNome.text;
      nivel.modifiedAt = hoje;
      nivel.isativo = _isativo;
      ApiResponse<bool> response =
          (await CategoriaApi.save(context, nivel)) as ApiResponse<bool>;

      if (response.ok) {
        alert(context, "Categoria editada com sucesso", callback: () {});
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.categoria);
      });

      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Categoria c) {
    var cate = c ?? Categoria();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    CategoriaApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.categoria);
    });
  }
}
