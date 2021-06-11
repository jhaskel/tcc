import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/af/afAdd/Af.dart';
import 'package:unigran_tcc/screens/af/Af.dart';
import 'package:unigran_tcc/screens/af/afAdd/af_api.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens.dart';
import 'package:unigran_tcc/screens/pedidoItens/PedidoItens_bloc.dart';
import 'package:intl/intl.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/api_response.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:unigran_tcc/utils/utils.dart';
import 'package:unigran_tcc/widgets/text_error.dart';

class AfDetalhe extends StatefulWidget {
  final Af af;
  final Usuario user;
  AfDetalhe({this.af, this.user});

  @override
  _AfDetalheState createState() => _AfDetalheState();
}

AfAdd afAdd;

class _AfDetalheState extends State<AfDetalhe> {
  final _bloc = PedidoItensBloc();
  final BlocAf blocaf = BlocProvider.getBloc<BlocAf>();
  List<PedidoItens> listItens;
  List<int> listEscolas = [];

  final tQuantidade = TextEditingController();
  var _showProgress = false;
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  int total = 0;

  iniciaBloc() {

    _bloc.fetchAf(context, widget.af.code).then((value) {
      setState(() {
        listItens = value;
        var x = listItens.map((e) => e.escola).toSet().toList();
        for (var x in x) {
          listEscolas.add(x);
        }
        print('listF$listEscolas');
      });
    });
  }

  @override
  void initState() {
    afAdd = AfAdd(
      id: widget.af.id,
      fornecedor: widget.af.fornecedor,
      code: widget.af.code,
      isativo: widget.af.isativo,
      isenviado: widget.af.isenviado,
      createdAt: widget.af.createdAt,
      status: widget.af.status,
    );
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
      centerTitle: true,
        title: Text('detalhe da af #${widget.af.code}'),
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
                return Center(child: TextError("Não foi possível buscar os Dados"));
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              listItens = snapshot.data;

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
                            'Escola',
                            style: AppTextStyles.titleBoldBlack,
                            textAlign: TextAlign.left,
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
                            PedidoItens i = listItens[index];
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
                                      child: Text(i.nomec),
                                    ),
                                     Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(i.unidade),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        i.quantidade.toString(),
                                        textAlign: TextAlign.center,
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
                                  ],
                                ),
                                Divider()
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            }),
        Positioned(
            bottom: 0,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: AppColors.secundaria,
              child: Column(
                children: [
                  (!widget.af.isenviado)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: FlatButton(
                              color: Colors.lightBlue,
                              onPressed: () {
                                enviarAf(widget.af);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Enviar Af Fornecedor',
                                  style: AppTextStyles.titleBold,
                                ),
                              )),
                        )
                      : Container(),
                  Text(
                    'Valor do Af R\$ ${formatador.format(widget.af.tot)}',
                    style: AppTextStyles.titleBold,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )),
        _showProgress
            ? Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    'Aguarde....',
                    style: AppTextStyles.heading40White,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Future<void> enviarAf(Af af) async {
    setState(() {
      _showProgress = true;
    });

    var afs = afAdd ?? AfAdd();
    afs.status = Status.pedidoFornecedor;
    afs.isenviado = true;
    ApiResponse<bool> response = await AfAddApi.save(context, afs);

    if (response.ok) {
    blocaf.decrementar();
      setState(() {
        _showProgress = false;
        Navigator.pop(context, true);
      });

      alert(context, "Af Enviada com sucesso", callback: () {});
    } else {
      alert(context, response.msg);
    }
  }
}
