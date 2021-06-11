import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Counterl extends StatefulWidget {
  int value = 0;
  void increment() => value++;
  void decrement() => value--;
  @override
  State<StatefulWidget> createState() {

    throw UnimplementedError();
  }
}
