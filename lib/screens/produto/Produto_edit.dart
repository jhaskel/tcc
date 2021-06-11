import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/categoria/Categoria.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor.dart';

import 'package:unigran_tcc/screens/produto/Produto.dart';
import 'package:unigran_tcc/screens/produto/Produto_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/categoria_bloc.dart';
import 'package:unigran_tcc/utils/bloc/fornecedor_bloc.dart';
import 'package:unigran_tcc/widgets/app_button.dart';
import 'package:unigran_tcc/widgets/app_tff.dart';
import 'package:validadores/Validador.dart';

class ProdutoEdit extends StatefulWidget {
  final Produto produto;

  ProdutoEdit({this.produto}) : super();

  @override
  _ProdutoEditState createState() => _ProdutoEditState();
}

class _ProdutoEditState extends State<ProdutoEdit> {
  Produto get produto => widget.produto;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: "produto_form");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  Color cor = Colors.white;

  var _showProgress = false;
  final tCode = TextEditingController();
  final tNome = TextEditingController();
  final tAlias = TextEditingController();
  final tCategoria = TextEditingController();
  final tFornecedor = TextEditingController();
  final tImage = TextEditingController();
  final tQuantidade = TextEditingController();
  final tEstoque = TextEditingController();
  final tValor = TextEditingController();
  final tAgro = TextEditingController();
  final tAno = TextEditingController();
  final tEscolas = TextEditingController();
  final tUnidade = TextEditingController();

  int _radioAgroIndex = 0;
  int idCategoria;
  int idFornecedor;
  String nomeCategoria;
  String nomeFornecedor;
  Map<String, int> mapCategoria = new Map();
  Map<int, String> mapCategoria2 = new Map();
  List<Categoria> categoria;

  Map<String, int> mapFornecedor = new Map();
  Map<int, String> mapFornecedor2 = new Map();

  List<Fornecedor> fornecedor;
  bool _isativo;

  getNomeCategoria(String data) {
    int jk = int.parse(data);
    if (mapCategoria2.containsKey(jk)) {
      setState(() {
        idCategoria = jk;
      });
      return mapCategoria2[jk];
    }
  }

  getNomeFornecedor(String data) {
    int jk = int.parse(data);
    if (mapFornecedor2.containsKey(jk)) {
      setState(() {
        idFornecedor = jk;
      });
      return mapFornecedor2[jk];
    }
  }

  @override
  void initState() {
 Provider.of<CategoriaBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
     for (var gh in value) {
          mapCategoria.putIfAbsent(gh.nome, () => gh.id);
        }
        print('mapCategoria${mapCategoria}');

        for (var gh in value) {
          mapCategoria2.putIfAbsent(gh.id, () => gh.nome);
        }
        print('mapCategoria2${mapCategoria2}');

    });});





 Provider.of<FornecedorBloc>(context, listen: false).fetch(context).then((value) {
    setState(() {
     setState(() {
        for (var gh in value) {
          mapFornecedor.putIfAbsent(gh.nome, () => gh.id);
        }

        for (var gh in value) {
          mapFornecedor2.putIfAbsent(gh.id, () => gh.nome);
        }
      });


    });  });




    if (produto != null) {
      tNome.text = produto.nome;
      tCode.text = produto.code;
      tAlias.text = produto.alias;
      tImage.text = produto.image;
      tQuantidade.text = produto.quantidade.toString();
      tCategoria.text = produto.categoria.toString();
      tFornecedor.text = produto.fornecedor.toString();
      tValor.text = produto.valor.toString();
      _radioAgroIndex = getAgroInt(produto);

      tUnidade.text = produto.unidade;
    }
    super.initState();
  }

  getAgroInt(Produto produto) {
    switch (produto.agrofamiliar) {
      case true:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    tCategoria.text = nomeCategoria;
    tFornecedor.text = nomeFornecedor;
    _isativo = produto.isativo;
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.alias),
        centerTitle: true,
        actions: [
          MergeSemantics(
            child: CupertinoSwitch(
              value: _isativo,
              onChanged: (bool newValue) {
                setState(() {
                  _isativo = newValue;
                });
                alteraStatus(newValue, produto);
              },
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Card(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Cadastro de Produtos",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Código',
                    hint: 'código do produto',
                    controller: tCode,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
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
                    hint: 'feijão, arrroz....',
                    controller: tAlias,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Unidade',
                    hint: 'kg, pct, und',
                    controller: tUnidade,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapCategoria.keys.toList(),
                        label: "Categoria",
                        onChanged: (String data) {
                          setState(() {
                            idCategoria = mapCategoria[data];
                            nomeCategoria = data;
                          });
                        },
                        selectedItem: getNomeCategoria(tCategoria.text)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItem: true,
                        items: mapFornecedor.keys.toList(),
                        label: "Fornecedor",
                        onChanged: (String data) {
                          setState(() {
                            idFornecedor = mapFornecedor[data];
                            nomeFornecedor = data;
                          });
                        },
                        selectedItem: getNomeFornecedor(tFornecedor.text)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: AppTFF(
                    label: 'Imagem',
                    hint: 'endereço da internet',
                    controller: tImage,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Quantidade',
                    hint: '100,120....',
                    controller: tQuantidade,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Container(
                      child: AppTFF(
                    label: 'Valor',
                    hint: '2.56, 75.63, 74.00.....',
                    controller: tValor,
                    validator: (text) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .valido(text, clearNoNumber: false);
                    },
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Agricultura Familiar?'),
                      ),
                      Container(
                        width: 200,
                        child: _radioAgro(),
                      )
                    ],
                  ),
                  Divider(
                    height: 10.0,
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

  bool _getAgro() {
    switch (_radioAgroIndex) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
    }
  }

  _radioAgro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: Colors.green,
          value: 0,
          groupValue: _radioAgroIndex,
          onChanged: _onClickAgro,
        ),
        Text(
          "Não",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          activeColor: Colors.green,
          value: 1,
          groupValue: _radioAgroIndex,
          onChanged: _onClickAgro,
        ),
        Text(
          "Sim",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickAgro(int value) {
    setState(() {
      _radioAgroIndex = value;
    });
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });

      var hoje = DateTime.now().toIso8601String();

      String quant = tQuantidade.text;
      double quantidade;
      if (quant.contains(',')) {
        quant = quant.replaceAll(".", "");
        quant = quant.replaceAll(",", ".");
        quantidade = double.parse(quant);
      } else {
        quantidade = double.parse(quant);
      }
      String valor1 = tValor.text;
      double valor;
      if (quant.contains(',')) {
        valor1 = valor1.replaceAll(".", "");
        valor1 = valor1.replaceAll(",", ".");
        valor = double.parse(valor1);
      } else {
        valor = double.parse(valor1);
      }
      // Cria o usuario
      var produ = produto ?? Produto();
      produ.code = tCode.text;
      produ.nome = tNome.text;
      produ.alias = tAlias.text;
      produ.categoria = idCategoria;
      produ.fornecedor = idFornecedor;
      produ.image = tImage.text;
      produ.unidade = tUnidade.text;
      produ.quantidade = quantidade;
      produ.estoque = quantidade;
      produ.agrofamiliar = _getAgro();
      produ.valor = valor;
      produ.ano = DateTime.now().year;
      produ.isativo = true;
      produ.createdAt = hoje;
      produ.modifiedAt = hoje;

      ApiResponse<bool> response = await ProdutoApi.save(context, produ);

      if (response.ok) {
        tCode.clear();
        tNome.clear();
        tAlias.clear();
        tImage.clear();
        tUnidade.clear();
        tQuantidade.clear();
        tValor.clear();

        alert(context, "Produto salvo com sucesso", callback: () {
          Navigator.of(context).pop();
        });
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
        bloc_bloc.inPage.add(AppPages.produto);
      });
      print("Fim.");
    }
  }

  void alteraStatus(bool newValue, Produto produto) {
    var cate = produto ?? Produto();
    cate.isativo = newValue;
    cate.modifiedAt = DateTime.now().toIso8601String();
    ProdutoApi.save(context, cate);
    setState(() {
      bloc_bloc.inPage.add(AppPages.produto);
    });
  }
}
