import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/af/afAdd/Af.dart';
import 'package:unigran_tcc/screens/af/afAdd/af_api.dart';
import 'package:unigran_tcc/screens/afPedido/AfPedido.dart';
import 'package:unigran_tcc/screens/afPedido/afPedido_api.dart';
import 'package:unigran_tcc/screens/comprar/Compras.dart';
import 'package:unigran_tcc/screens/comprar/Compras_api.dart';
import 'package:unigran_tcc/screens/comprar/compras_bloc.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pedido/Pedido.dart';
import 'package:unigran_tcc/screens/pedido/pedidoAdd/PedidoAdd.dart';
import 'package:unigran_tcc/screens/pedido/pedidoAdd/PedidoAdd_api.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class PedidoDetalhe extends StatefulWidget {
  final Pedido pedido;
  final Usuario user;
  PedidoDetalhe({this.pedido, this.user});

  @override
  _PedidoDetalheState createState() => _PedidoDetalheState();
}

PedidoAdd pedidoAdd;

class _PedidoDetalheState extends State<PedidoDetalhe> {
  final _bloc = ComprasBloc();
  List<Compras> listItens;
  List<int> listFornecedores = [];
  Usuario get user => widget.user;

  final tQuantidade = TextEditingController();
  var _showProgress = false;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  double totalPedido;
  int step;
  int currentStep = 0;
  int total = 0;
  int _itens = 0;

  iniciaBloc() async {
    pedidoAdd = PedidoAdd(
      id: widget.pedido.id,
      total: widget.pedido.total,
      isaf: widget.pedido.isaf,
      isativo: widget.pedido.isativo,
      createdAt: widget.pedido.createdAt,
      escola: widget.pedido.escola,
      modifiedAt: widget.pedido.modifiedAt,
      status: widget.pedido.status,
    );

    await _bloc.fetchPedidoAll(context, widget.pedido.id).then((value) {
      setState(() {
        listItens = value;
        var x = listItens.map((e) => e.fornecedor).toSet().toList();
         var xy = listItens.map((e) => e.total).toSet().toList();

         totalPedido = xy.reduce((a, b) => a+b);
         print("TOOO $totalPedido");
         _itens = listItens.length;
          print("ITENS $_itens");
        for (var x in x) {
          listFornecedores.add(x);

        }
      });
    });
  }

  @override
  void initState() {
    iniciaBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading:IconButton(
      icon: Icon(Icons.arrow_back),
       onPressed: (){
       Navigator.pop(context, true);
       }

      ),
        centerTitle: true,
        title: Text('detalhe do pedido #${widget.pedido.id}'),
      ),
      body: _body(),
    );
  }

  _body() {
    return Stack(
      children: [
        StreamBuilder(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: TextError(
                        "Não foi possível buscar os ítens do pedido"));
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              listItens = snapshot.data;
              return _item();
            }),
        user.escola == 0
            ? Positioned(
                bottom: 0,
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.secundaria,
                  child: Column(
                    children: [
                      (!widget.pedido.isaf)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    _geraAf();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Gerar Af',
                                      style: AppTextStyles.titleBold,
                                    ),
                                  )),
                            )
                          : Container(),
                      Text(
                        'Valor do Pedido R\$ ${formatador.format(widget.pedido.total)}',
                        style: AppTextStyles.titleBold,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ))
            : Container(),
        _showProgress
            ? Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Aguarde....',
                        style: AppTextStyles.heading40White,
                      ),
                      CircularStepProgressIndicator(
                        totalSteps: step,
                        currentStep: currentStep,
                        stepSize: 10,
                        selectedColor: AppColors.secundaria,
                        unselectedColor: AppColors.grey,
                        padding: 0,
                        width: 150,
                        height: 150,
                        selectedStepSize: 15,
                        roundedCap: (_, __) => true,
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Padding _item() {
    return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Text(
                          'Produto',
                          style: AppTextStyles.titleBoldBlack,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          'Unidade',
                          style: AppTextStyles.titleBoldBlack,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          'Quantidade',
                          style: AppTextStyles.titleBoldBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          'Valor',
                          style: AppTextStyles.titleBoldBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          'Total',
                          style: AppTextStyles.titleBoldBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          '#',
                          style: AppTextStyles.titleBoldBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: listItens.length,
                        itemBuilder: (context, index) {
                          Compras i = listItens[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 4,
                                    fit: FlexFit.tight,
                                    child: Text(i.alias),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(i.unidade),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Row(
                                    children: [
                                    !widget.pedido.isaf ?IconButton(
                                    icon: Icon(Icons.indeterminate_check_box),
                                    onPressed: (){
                                     decrement(i);

                                    }):Container(),
                                    Text(
                                        i.quantidade.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                       !widget.pedido.isaf? IconButton(
                                    icon: Icon(Icons.add_box),
                                    onPressed: (){
                                    increment(i);
                                    }):Container(),

                                    ],

                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      'R\$ ${formatador.format(i.valor)}',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      'R\$ ${formatador.format(i.total)}',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: i.af == 0
                                        //se nao tiver af pode deletar]
                                        ? IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () =>
                                                showExcluir(context, i),
                                          )
                                        //se tiver af não pode mais deletar
                                        : IconButton(
                                            icon: Icon(
                                                Icons.delete_forever_sharp),
                                            onPressed: null,
                                          ),
                                  ),
                                ],
                              ),
                              Divider(thickness: 1)
                            ],
                          );
                        }),
                  ),
                ],
              ),
            );
  }

  increment(Compras c) async {
  setState(() {

  });
    var quant = c.quantidade + 1;
        alteraQuantidade(c, quant, c.valor,true);
  }

  decrement(Compras c) async {
   setState(() {
  });
    if (c.quantidade > 1) {
      var quant = c.quantidade - 1;
      alteraQuantidade(c, quant, c.valor,false);
    }
  }

  alteraQuantidade(Compras c, double quant, double valor, bool inc) async {
  var hoje = DateTime.now().toIso8601String();

    var itee = c ?? Compras();
    itee.id = c.id;
    itee.quantidade = quant;
    itee.total = inc ?c.total + valor:c.total-valor;
    await ComprasApi.save(context, itee);


    print("totalantes = $totalPedido");
    await iniciaBloc();
    print("totalPedidodepois ${totalPedido}");
    var ped = pedidoAdd ?? PedidoAdd();
    ped.id = pedidoAdd.id;
    ped.total = totalPedido;
    ped.modifiedAt = hoje;
    await PedidoAddApi.save(context, ped);
  }

  Future<void> _geraAf() async {

    AfAdd af;
    AfPedido afpedido;

    var codex = DateFormat("yyMMdd").format(DateTime.now());

    var lista = listFornecedores.toList();
    setState(() {
      _showProgress = true;
      step = lista.length;

    });

    print(lista);
    for (var forn in lista) {
      var tot = listItens.where((e) => e.fornecedor == forn);
      var tot1 = tot.map((e) => e.total);
      var total = tot1.reduce((a, b) => a + b);
      var code = ('$codex$forn');
      var afp = afpedido ?? AfPedido();
      afp.af = int.parse(code);
      afp.pedido = widget.pedido.id;
      afp.total = total;
      afp.fornecedor = forn;
      AfPedidoApi.save(context, afp);

      var afs = af ?? AfAdd();
      afs.code = int.parse(code);
      afs.createdAt = DateTime.now().toIso8601String();
      afs.fornecedor = forn;
      afs.isenviado = false;
      afs.status = Status.pedidoProcessado;
      afs.isativo = true;
      await AfAddApi.save(context, afs);

      setState(() {
         currentStep++;
      });

      Compras itek;
      for (var ite in listItens) {
        itek = ite;

        if (ite.fornecedor == forn) {

          var itee = itek ?? Compras();
          itee.id = itek.id;
          itee.af = int.parse(code);
          print(itee);
          ComprasApi.save(context, itee);
        }
      }

      print('${codex}${forn} - ${total}');
    }
    var afs = pedidoAdd ?? PedidoAdd();
    afs.status = Status.pedidoProcessado;
    afs.isaf = true;
    await PedidoAddApi.save(context, afs);

    setState(() {
      _showProgress = false;
    });
    Navigator.pop(context, true);
  }

  showExcluir(
    BuildContext context,
    Compras dados,
  ) {

    Widget cancelaButton = MaterialButton(
      child: Text("Cancelar"),
      onPressed: () {
        pop(context);
      },
    );
    Widget continuaButton = MaterialButton(
      child: Text("Excluir"),
      onPressed: () async {
        setState(() {
          listItens.removeWhere((element) => element.id == dados.id);
        });
        _onClickExcuir(dados);
        pop(context);
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${dados.alias} '),
      content: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Tem certeza que desja excluir esse registro?'),
            ),
          ],
        ),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _onClickExcuir(Compras dados) async {
print('quantItens0 $_itens');

    var dado = dados ?? Compras();
    dado.id = dados.id;
    await ComprasApi.delete(context, dado).then((value) => _itens--);

    if(_itens >0 ){
    await iniciaBloc();
    }
    var ped = pedidoAdd ?? PedidoAdd();
    ped.id = pedidoAdd.id;
    ped.total = totalPedido;
    await PedidoAddApi.save(context, ped);

    print('quantitens2 $_itens');
    if (_itens ==0) {
      print("não tem mais");
      var ped = pedidoAdd ?? PedidoAdd();
      ped.id = pedidoAdd.id;
      await PedidoAddApi.delete(context, ped);
    }
  }
}




