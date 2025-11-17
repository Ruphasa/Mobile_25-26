import 'dart:async';
import 'dart:math';

class RandomNumberBloc {
  final _streamController = StreamController<int>();

  Stream<int> get stream => _streamController.stream;

  void generateNumber() {
    Random random = Random();
    int number = random.nextInt(10);
    _streamController.sink.add(number);
  }

  void dispose() {
    _streamController.close();
  }
}