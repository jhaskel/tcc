import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/screens/consultas/cosultas_page.dart';
import 'package:unigran_tcc/screens/consultas/tabs_page.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/responsive.dart';
import 'package:unigran_tcc/screens/pages.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';

class MainScreen extends StatefulWidget {
  final Usuario user;
  MainScreen({this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String page;
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
  Usuario get user => widget.user;

  @override
  void initState() {
    bloc_bloc.inPage.add('home');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
          stream: bloc_bloc.outPage,
          builder: (context, snapshot) {
            page = snapshot.data;
            print('page $page');
            if(user.isPublico()){
            return TabsPage(user);
            }else
            return Responsive(
              // Let's work on our mobile part
              mobile: Row(
                children: [
                  Expanded(

                    child: PagesT(page, user),
                  ),
                ],
              ),
              tablet: Row(
                children: [
                  Expanded(

                    child: PagesT(page, user),
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    flex: _size.width > 1340 ? 2 : 4,
                    child: SideMenu(
                      user: user,
                    ),
                  ),
                  Expanded(
                    flex: _size.width > 1340 ? 8 : 10,
                    child: PagesT(page, user),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
