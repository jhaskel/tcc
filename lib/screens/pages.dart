import 'package:flutter/material.dart';
import 'package:unigran_tcc/components/header/app_bar.dart';
import 'package:unigran_tcc/components/menu/side_menu.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_add.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_detalhe.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_edit.dart';
import 'package:unigran_tcc/screens/cardapio/cardapio_page.dart';
import 'package:unigran_tcc/screens/config/Config_page.dart';
import 'package:unigran_tcc/screens/consultas/cosultas_page.dart';
import 'package:unigran_tcc/screens/testes/teste1.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/af/afPage.dart';
import 'package:unigran_tcc/screens/cart/cartPage.dart';
import 'package:unigran_tcc/screens/categoria/categoria_add.dart';
import 'package:unigran_tcc/screens/categoria/categoria_page.dart';
import 'package:unigran_tcc/screens/comprar/Comprar_page.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor_add.dart';
import 'package:unigran_tcc/screens/fornecedor/Fornecedor_page.dart';
import 'package:unigran_tcc/screens/main/home_page.dart';
import 'package:unigran_tcc/screens/main/home_page_escolas.dart';
import 'package:unigran_tcc/screens/main/home_page_fornecedor.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_add.dart';
import 'package:unigran_tcc/screens/nivelEscolar/NivelEscolar_page.dart';
import 'package:unigran_tcc/screens/pedido/Pedido_page.dart';
import 'package:unigran_tcc/screens/pedido/pedido_detalhe.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_add.dart';
import 'package:unigran_tcc/screens/pnae/Pnae_page.dart';
import 'package:unigran_tcc/screens/produto/Produto_add.dart';
import 'package:unigran_tcc/screens/produto/Produto_mais.dart';
import 'package:unigran_tcc/screens/produto/Produto_menos.dart';
import 'package:unigran_tcc/screens/produto/Produto_page.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_add.dart';
import 'package:unigran_tcc/screens/unidadeEscolar/UnidadeEscolar_page.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_add.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_page.dart';

class PagesT extends StatelessWidget {
  final String page;
  final Usuario user;
  PagesT(this.page, this.user);
  @override
  Widget build(BuildContext context) {
    var largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBarWidget(),
      ),
      body: _body(context),
      drawer: largura < 1100
          ? ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: SideMenu(user: user),
            )
          : Container(),
    );
  }

  _body(BuildContext context) {
    if (page == AppPages.home &&
        (user.isMaster() || user.isDev() || user.isAdmin())) {
      return HomePage(user);
    } else if (page == AppPages.home && user.isEscola()) {
      return HomePageEscolas(user);
    } else if (page == AppPages.home && user.isFornecedor()) {
      return FornecedorHome(user);
    } else if (page == AppPages.nivelEscolar) {
      return NivelEscolarPage();
    } else if (page == AppPages.nivelEscolarAdd) {
      return NivelEscolarAdd();
    } else if (page == AppPages.unidadeEscolar) {
      return UnidadeEscolarPage();
    } else if (page == AppPages.unidadeEscolarAdd) {
      return UnidadeEscolarAdd();
    } else if (page == AppPages.categoria) {
      return CategoriaPage();
    } else if (page == AppPages.categoriaAdd) {
      return CategoriaAdd();
    } else if (page == AppPages.fornecedor) {
      return FornecedorPage();
    } else if (page == AppPages.fornecedorAdd) {
      return FornecedorAdd();
    } else if (page == AppPages.fornecedorHome) {
      return FornecedorHome(user);
    } else if (page == AppPages.pnae) {
      return PnaePage();
    } else if (page == AppPages.pnaeAdd) {
      return PnaeAdd();
    } else if (page == AppPages.usuario) {
      return UsuarioPage();
    } else if (page == AppPages.usuarioAdd) {
      return UsuarioAdd();
    } else if (page == AppPages.produto) {
      return ProdutoPage();
    } else if (page == AppPages.produtoAdd) {
      return ProdutoAdd();
    } else if (page == AppPages.produtoMais) {
      return ProdutoMais();
    } else if (page == AppPages.produtoMenos) {
      return ProdutoMenos();
    } else if (page == AppPages.comprar) {
      return ComprarPage(user);
    } else if (page == AppPages.cart) {
      return CartPage(user);
    } else if (page == AppPages.pedido) {
      return PedidoPage(user);
    } else if (page == AppPages.pedidoDetalhe) {
      return PedidoDetalhe();
    } else if (page == AppPages.af) {
      return AfPage(user);
    } else if (page == AppPages.config) {
      return ConfigPage();
    } else if (page == AppPages.consulta) {
      return ConsultaPage(user);
    } else if (page == AppPages.cardapio) {
      return CardapioPage(user);
    } else if (page == AppPages.cardapioAdd) {
      return CardapioAdd(user);
    } else if (page == AppPages.cardapioDetalhe) {
      return CardapioDetalhe();
    } else if (page == AppPages.cardapioEdit) {
      return CardapioEdit();

      } else if (page == AppPages.teste) {
      return Teste1();
    } else {
      return HomePage(user);
    }
  }
}
