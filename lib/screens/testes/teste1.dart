import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:unigran_tcc/utils/mobx/controller.dart';

class Teste1 extends StatelessWidget {
  Controller controller = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test1"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
      controller.incrementar()();

      },
      child:Icon(Icons.add)


      ),
    );
  }

  _body() {
    return Center(child: Observer(builder: (_) {
      return Text(controller.contador.toString());
    }));
  }
}
