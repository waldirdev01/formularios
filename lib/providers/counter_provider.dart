import 'package:flutter/material.dart';

class CounterProvider extends InheritedWidget {
  CounterProvider({Key? key, required super.child}) : super(key: key);

  final CounterState state = CounterState();

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    return oldWidget.state.diff(state);
  }
}

class CounterState {
  int _value = 0;

  void inc() => _value++;

  void dec() => _value--;

  get value => _value;

  bool diff(CounterState old) {
    return old._value != _value;
  }
}
