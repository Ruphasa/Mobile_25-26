import 'package:flutter/material.dart';
import 'stream.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  //stream subscription part 2
  late StreamSubscription subscription2;
  String values = '';
  
  //stream subscription
  late StreamSubscription subscription;

  //stream color
  Color bgColor = Colors.blueGrey;
  late ColorStream colorStream;

  //stream number
  int lastNumber = 0;
  late StreamController numberStreamController;
  late NumberStream numberStream;

  //stream transformation
  late StreamTransformer transformer;

  @override
  void initState() {

    //stream transformation
    transformer = StreamTransformer<int, int>.fromHandlers(
      handleData: (value, sink) {
        sink.add(value * 10);
      },
      handleError: (error, stackTrace, sink) {
        sink.add(-1);
      },
      handleDone: (sink) => sink.close(),
    );

    //stream number
    numberStream = NumberStream();
    numberStreamController = numberStream.controller;
    Stream stream = numberStreamController.stream.asBroadcastStream();

    //stream subscription part 2
    subscription = stream.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });

    subscription2 = stream.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });

    //stream subscription
    subscription = stream.listen((event) {
      setState(() {
        lastNumber = event;
      });
    });

    subscription.onError((error) {
      setState(() {
        lastNumber = -1;
      });
    });

    subscription.onDone(() {
      print('onDone was called');
    });

    //stream color
    colorStream = ColorStream();
    changeColor();

    super.initState();
  }

  @override
  void dispose() {
    numberStream.close();
    subscription.cancel();
    super.dispose();
  }

  void changeColor() async {
    await for (var eventColor in colorStream.getColors()) {
      setState(() {
        bgColor = eventColor;
      });
    }
  }

  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);
    if (!numberStreamController.isClosed) {
      numberStream.addNumberToSink(myNum);
    }else{
      setState(() {
        lastNumber = -1;
      });
    }
  }

  void stopStream() {
    numberStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream')),
      body: Container(
        decoration: BoxDecoration(color: bgColor),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(values),
            Text(lastNumber.toString()),
            ElevatedButton(
              onPressed: addRandomNumber,
              child: const Text('Add Number'),
            ),
            ElevatedButton(
              onPressed: () => stopStream(),
              child: const Text('Stop Subs'),
            ),
          ],
        ),
      ),
    );
  }
}
