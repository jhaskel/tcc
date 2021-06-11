import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/config/Config.dart';
import 'package:unigran_tcc/screens/config/Config_api.dart';
import 'package:unigran_tcc/screens/config/Config_edit.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/nav.dart';

class ConfigListView extends StatefulWidget {
  List<Config> config;
  ConfigListView(this.config);

  @override
  _ConfigListViewState createState() => _ConfigListViewState();
}

class _ConfigListViewState extends State<ConfigListView> {
  //controle do scroll
  ScrollController _controller = ScrollController();
  bool _showProgress = false;
  List<Config> config2;
  //controle que define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();

  @override
  Widget build(BuildContext context) {

         return _grid(widget.config);
  }

  _grid(List<Config> config) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            controller: _controller,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _controller,
              itemCount: widget.config.length,
              itemBuilder: (context, index) {

                Config c = widget.config[index];

                  return _cardConfig(c,constraints,index);


              },
            ),
          ),
        );
      },
    );
  }


  _cardConfig(Config c, BoxConstraints constraints, int idx) {

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor:AppColors.secundaria,),

            title:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.entidade),
                Text(c.setor)
              ],


            ),
            subtitle:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.nomeContato),
                Text(c.cargo)
              ],


            ),

          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(onTap: (){
                    pop(context);
                    _onClickEdit(c);

                  },
                      child: Text("Editar")),
                ),
              ),


            ],
          ),



        ),
        Divider()

      ],

    );


  }


  void _onClickEdit(Config c) {
    push(context, ConfigEdit(config: c,));
  }


}
