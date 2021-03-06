import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/main/main_screen.dart';

class AppModel extends ChangeNotifier {
  static AppModel get(context, {bool listen = false}) =>
      Provider.of<AppModel>(context, listen: listen);

  Usuario _user;
  Usuario get user => _user;
  void setUser(Usuario u) {
    this._user = u;
    notifyListeners();
  }
}

class PageInfo {
  String title;
  Widget page;

  PageInfo(this.title, this.page);

  @override
  String toString() {
    return title;
  }
}

class PagesModel extends ChangeNotifier {
  static PagesModel get(context, {bool listen = false}) =>
      Provider.of<PagesModel>(context, listen: listen);

  List<PageInfo> pages = [];

  PageInfo defaultPage = PageInfo("Home", MainScreen());

  PagesModel() {
    pages.add(defaultPage);
  }

  push(PageInfo page, {bool replace = false}) {
    if (replace) {
      popAll();
    }

    if (page.title != "Home") {
      this.pages.add(page);
    }

    notifyListeners();
  }

  void pop() {
    this.pages.removeLast();

    notifyListeners();
  }

  void popAll() {
    this.pages.clear();
    pages.add(defaultPage);

    notifyListeners();
  }

  void popTo(int index) {
    pages.removeRange(index + 1, pages.length);

    notifyListeners();
  }
}
