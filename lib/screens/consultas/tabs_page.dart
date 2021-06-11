
import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/header/app_bar.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_page.dart';
import 'package:unigran_tcc/screens/consultas/cosultas_page.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
class TabsPage extends StatefulWidget {
final Usuario user;
  TabsPage(this.user);
  @override
  _TabsPageState createState() => new _TabsPageState();
}

class _TabsPageState extends State<TabsPage>
    with TickerProviderStateMixin {

  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();

      _tabs = [
        new Tab(text: 'Gastos com Merenda',),
        new Tab(text: 'Cardápio Escolar'),

      ];


      _pages = [
        ConsultaPage(widget.user),
        CardapioPage(widget.user),

      ];

   _initTabs();
  }
  _initTabs() async {
    _controller = TabController(length:  _tabs.length, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBarWidget(),
      ),
      body: _body(),

    );


  }

  _body() {
    double altura = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            labelColor: Theme.of(context).accentColor,
            indicatorColor: Theme.of(context).accentColor,
          ),
          new SizedBox.fromSize(
            size:  Size.fromHeight(altura-140),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
