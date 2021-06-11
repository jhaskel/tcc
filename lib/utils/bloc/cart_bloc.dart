import 'package:flutter/widgets.dart';
import 'package:unigran_tcc/screens/cart/Cart.dart';

class CartBloc extends ChangeNotifier {
  List<Cart> cart = [];
  double total = 0;
  double itens = 0;

  get() {
    return cart;
  }

  add(Cart item) {
    cart.add(item);
    calculateTotal();
    increase(item);
  }

  remove(Cart item) {
    cart.removeWhere((x) => x.id == item.id);
    calculateTotal();
    decrease(item);
  }

  removeAll() {
    cart.clear();
    notifyListeners();
  }

  itemInCart(Cart item) {
    var result = false;
    cart.forEach((x) {
      if (item.id == x.id) result = true;
    });

    return result;
  }

  increase(Cart item) {
    itens = 0;

    cart.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  increment(Cart item) {
    total = total + item.valor;

    notifyListeners();
  }

  decrement(Cart item) {
    total = total - item.valor;

    notifyListeners();
  }

  decrease(Cart item) {
    itens = 0;

    cart.forEach((x) {
      itens--;
    });
    notifyListeners();
  }

  calculateTotal() {
    total = 0;
    cart.forEach((x) {
      total += (x.valor * x.quantidade);
    });
    notifyListeners();
  }

  calculateItens() {
    itens = 0;
    cart.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
}
