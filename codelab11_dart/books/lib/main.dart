import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FutureGroup Demo', home: const FuturePage());
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});
  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';

  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  void runParallel() {
    final futureGroup = FutureGroup<int>();
    futureGroup.add(returnOneAsync());
    futureGroup.add(returnTwoAsync());
    futureGroup.add(returnThreeAsync());
    futureGroup.close();
    futureGroup.future.then((values) {
      final sum = values.reduce((a, b) => a + b);
      setState(() {
        result = sum.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back from the Future')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('GO!'),
              onPressed: () {
                returnError()
                  .then((value){
                    setState(() {
                      result = 'Success';
                    });
                  }).catchError((onError){
                    setState(() {
                      result = onError.toString();
                    });
                  }).whenComplete(() => print('Complete'));
              },
            ),
            const SizedBox(height: 24),
            Text(result, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future returnError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Something terrible happened!');
  }

  // Future handleError() async {
  //   try {} catch (error) {
  //     setState(() {
  //       result = error.toString();
  //     });
  //   } finally {
  //     print('Complete');
  //   }
  // }
}
