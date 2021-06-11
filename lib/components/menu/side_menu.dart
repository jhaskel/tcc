import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/cadastros.dart';
import 'package:unigran_tcc/components/menu/consultas.dart';
import 'package:unigran_tcc/components/menu/side_menu_item.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/responsive.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/bloc/bloc_af.dart';
import 'package:unigran_tcc/utils/bloc/bloc_pedido.dart';
import 'package:unigran_tcc/utils/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {
  final Usuario user;

   SideMenu(  {this.user,
     Key key,
   }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();

}

class _SideMenuState extends State<SideMenu> {

  String page;
  //define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  final BlocPedido blocPedido = BlocProvider.getBloc<BlocPedido>();
  final BlocAf blocAf = BlocProvider.getBloc<BlocAf>();
  Usuario get user=>widget.user;
  @override
  Widget build(BuildContext context) {
  print('llll${user.isEscola()}');
       return InkWell(
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: AppColors.kBgLightColor,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child:  Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/brasao.png",
                          width: 46,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MERENDA',style: AppTextStyles.bodyLightGrey20,),
                            Text('ESCOLAR',style: AppTextStyles.bodyLightGrey20,),
                          ],
                        ),
                        Spacer(),
                        // We don't want to show this close button on Desktop mood
                        if (!Responsive.isDesktop(context)) CloseButton(),
                      ],
                    ),

                    SizedBox(height: kDefaultPadding * 2),
                    // Menu Items
                    SideMenuItem(
                      press: () {
                          page = AppPages.home;
                          bloc_bloc.inPage.add(page);
                          bloc_bloc.inTextAppBar.add('Merenda Escolar');

                      },
                      title: "Home",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: page == AppPages.home?true:false,

                    ),
                    user.isEscola()? SideMenuItem(
                      press: () {
                        page = AppPages.comprar;
                        bloc_bloc.inPage.add(page);
                        bloc_bloc.inTextAppBar.add('Compras');

                      },
                      title: "Comprar",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: page == AppPages.comprar?true:false,

                    ):Container(),

                    !user.isFornecedor()? StreamBuilder(
                      stream: blocPedido.outQuant,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return SideMenuItem(
                          press: () {
                            page =AppPages.pedido;
                            bloc_bloc.inPage.add(page);
                            bloc_bloc.inTextAppBar.add('Pedidos');

                          },
                          title: "Pedidos",
                          iconSrc: "assets/Icons/Send.svg",
                          isActive: page == AppPages.pedido?true:false,
                          itemCount:user.isMaster()|| user.isAdmin() || user.isDev()
                            ? snapshot.data>0?snapshot.data:null
                            :null,
                        );
                      }
                    ):Container(),

                    user.isMaster()|| user.isAdmin() || user.isDev()?StreamBuilder(
                      stream: blocAf.outQuant,
                      builder: (context, snapshot) {
                        return SideMenuItem(
                          press: () {
                            page =AppPages.af;
                            bloc_bloc.inPage.add(page);
                            bloc_bloc.inTextAppBar.add('Af');
                          },
                          title: "Af",
                          iconSrc: "assets/Icons/File.svg",
                          isActive: page == AppPages.af? true:false,
                          itemCount: snapshot.data>0?snapshot.data:null,
                        );
                      }
                    ):Container(),

                    SizedBox(height: kDefaultPadding * 2),
                    // Tags
                    user.isMaster()|| user.isAdmin() || user.isDev()? Cadastros():Container(),
                    user.isMaster()|| user.isAdmin() || user.isDev()? Consultas():Container(),

                    user.isMaster()|| user.isAdmin() || user.isDev()?SideMenuItem(
                      press: () {
                        page =AppPages.config;
                        bloc_bloc.inPage.add(page);
                         bloc_bloc.inTextAppBar.add('Configurações');

                      },
                      title: "Configurações",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: page == AppPages.config?true:false,

                    ):Container(),
                  ],
                )

          ),
        ),
      ),
    );
  }
}
