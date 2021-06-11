import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';

class AppBarWidget extends StatelessWidget {
   AppBarWidget({
    Key key,
  }) : super(key: key);
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
   final BlocPedido blocPedido = BlocProvider.getBloc<BlocPedido>();
  String title;

  @override
  Widget build(BuildContext context) {
    var largura = MediaQuery.of(context).size.width;
    print("largura $largura");
    return StreamBuilder(
        stream: bloc_bloc.outTextAppBar,
      builder: (context, snapshot) {
        title = snapshot.data;
        return Container(
          height: 60,
          color: AppColors.primaria,
          padding:
          EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Builder(
                builder: (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: largura < 1100 ? Icon(Icons.menu,color: AppColors.white,):Container()),
              ),
              Text(
                title,
                style: AppTextStyles.titleBold,
              ),
              PopupMenuButton<String>(

                padding: EdgeInsets.zero,
                onSelected: (value) {
                  _onClickOptionMenu(context, value);
                },
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 28,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) => _getActions(),
              ),
            ],
          ),
        );
      }
    );
  }

  _getActions() {
    return <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: "meus_dados",
        child: Text("Meus dados"),
      ),

      PopupMenuItem<String>(
        value: "logout",
        child: Text("Logout"),
      ),
    ];
  }

  void _onClickOptionMenu(context, String value) {
    if ("logout" == value) {
      logout(context);
    } else if ("meus_dados" == value) {

    }  else {}
  }
}
