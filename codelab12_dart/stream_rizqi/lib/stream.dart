import 'package:flutter/material.dart';
import 'dart:async';

class NumberStream {
  final StreamController<int> controller = StreamController<int>();
  void addNumberToSink(int number) {
    controller.sink.add(number);
  }

  void close() {
    controller.close();
  }
}

class ColorStream {
  final List<Color> colors = [
    Colors.blueGrey,
    Colors.indigo,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.teal,
  ];

  Stream<Color> getColors() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int t) {
      int index = t % colors.length;
      return colors[index];
    });
  }
}
