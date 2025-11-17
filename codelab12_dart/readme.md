# README - Laporan Praktikum Flutter: State Management dengan Streams (Week 12)

## Identitas

- **Nama:** Rizqi Fauzan
- **NIM:** 2341720143
- **Kelas:** Kelas T-3H

---

## Praktikum 1: Dart Streams

### Soal Praktikum

**Soal 1:**

- Tambahkan **nama panggilan Anda** pada `title` app sebagai identitas hasil pekerjaan Anda.
- Gantilah warna tema aplikasi sesuai kesukaan Anda.
- Lakukan commit hasil jawaban Soal 1 dengan pesan **"W12: Jawaban Soal 1"**

```dart
  title: const Text('Stream Rizqi'),
```

**Soal 2:**

- Tambahkan 5 warna lainnya sesuai keinginan Anda pada variabel `colors` tersebut.
- Lakukan commit hasil jawaban Soal 2 dengan pesan **"W12: Jawaban Soal 2"**

**Soal 3:**

- Jelaskan fungsi keyword `yield*` pada kode tersebut!
- Apa maksud isi perintah kode tersebut?
- Lakukan commit hasil jawaban Soal 3 dengan pesan **"W12: Jawaban Soal 3"**

**Soal 4:**

- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lakukan commit hasil jawaban Soal 4 dengan pesan **"W12: Jawaban Soal 4"**

**Soal 5:**

- Jelaskan perbedaan menggunakan `listen` dan `await for` (langkah 9)!
- Lakukan commit hasil jawaban Soal 5 dengan pesan **"W12: Jawaban Soal 5"**

### Code Final

**main.dart:**

```dart
import 'package:flutter/material.dart';
import 'stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
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
  Color bgColor = Colors.blueGrey;
  late ColorStream colorStream;

  @override
  void initState() {
    super.initState();
    colorStream = ColorStream();
    changeColor();
  }

  void changeColor() async {
    await for (var eventColor in colorStream.getColors()) {
      setState(() {
        bgColor = eventColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream'),
      ),
      body: Container(
        decoration: BoxDecoration(color: bgColor),
      ),
    );
  }
}

```

**stream.dart:**

```dart
import 'package:flutter/material.dart';

class ColorStream {
  final List<Color> colors = [
    Colors.blueGrey,
    Colors.amber,
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
```

---

## Praktikum 2: Stream Controllers dan Sinks

### Soal Praktikum

**Soal 6:**

- Jelaskan maksud kode langkah 8 dan 10 tersebut!
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 6**".

**Soal 7:**

- Jelaskan maksud kode langkah 13 sampai 15 tersebut!
- Kembalikan kode seperti semula pada Langkah 15, comment `addError()` agar Anda dapat melanjutkan ke praktikum 3 berikutnya.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 7**".

### Code Final

**stream.dart (tambahan NumberStream class):**

```dart
import 'dart:async';

class NumberStream {
  final _streamController = StreamController<int>();

  void addNumberToSink(int number) {
    _streamController.sink.add(number);
  }

  Stream<int> get stream => _streamController.stream;

  void close() {
    _streamController.close();
  }
}
```

**main.dart (modifikasi pada initState dan tambah method):**

```dart
  int lastNumber = 0;
  late StreamController numberStreamController;
  late NumberStream numberStream;

  @override
  void initState() {
    numberStream = NumberStream();
    numberStreamController = numberStream.controller;
    Stream stream = numberStreamController.stream;
    stream.listen((event) {
      setState(() {
        lastNumber = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    numberStream.close();
    super.dispose();
  }

  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);
    numberStream.addNumberToSink(myNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Rizqi')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(lastNumber.toString()),
            ElevatedButton(onPressed: addRandomNumber, child: const Text('Add Number'))
          ],
        ),
      ),
    );
  }
```

---

## Praktikum 3: Injeksi Data ke Streams

### Soal Praktikum

**Soal 8:**

- Jelaskan maksud kode langkah 1-3 tersebut!
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 8**".

### Code Final

**main.dart (tambahan variabel dan initState):**

```dart
late StreamTransformer transformer;

@override
void initState() {
  super.initState();
  transformer = StreamTransformer<int, int>.fromHandlers(
    handleData: (value, sink) {
      sink.add(value * 10);
    },
    handleError: (error, trace, sink) {
      sink.add(-1);
    },
    handleDone: (sink) => sink.close(),
  );

  stream.transform(transformer).listen((event) {
      setState(() {
        lastNumber = event;
      });
    }).onError((error) {
      setState(() {
        lastNumber = -1;
      });
    });
}
```

---

## Praktikum 4: Subscribe ke Stream Events

### Soal Praktikum

**Soal 9:**

- Jelaskan maksud kode langkah 2, 6 dan 8 tersebut!
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 9**".

### Code Final

**main.dart (modifikasi initState dengan Subscription):**

```dart
late StreamSubscription subscription;

@override
void initState() {
  super.initState();
  subscription = numberStream.stream.listen((event) {
    setState(() {
      lastNumber = event;
    });
  }, onError: (error) {
    // Handle error
  }, onDone: () {
    // Handle done
  });
}

@override
void dispose() {
  subscription.cancel();
  super.dispose();
}
```

---

## Praktikum 5: Multiple Stream Subscriptions

### Soal Praktikum

**Soal 10:**

- Jelaskan mengapa error itu bisa terjadi?

**Soal 11:**

- Jelaskan mengapa hal itu bisa terjadi?
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 10,11**".

### Code Final

**main.dart (menggunakan broadcast stream):**

```dart
late StreamSubscription subscription2;
String values = '';

@override
void initState() {
  super.initState();
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
}
```

---

## Praktikum 6: StreamBuilder

### Soal Praktikum

**Soal 12:**

- Jelaskan maksud kode pada langkah 3 dan 7!
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 12**".

### Code Final

**stream.dart (NumberStream class):**

```dart
import 'dart:math';
import 'dart:async';

class NumberStream {
  Stream<int> getNumbers() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int t) {
      Random random = Random();
      int myNum = random.nextInt(10);
      return myNum;
    });
  }
}
```

**main.dart (menggunakan StreamBuilder):**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('StreamBuilder')),
    body: StreamBuilder<int>(
      stream: numberStream.getNumbers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Text(
              snapshot.data.toString(),
              style: const TextStyle(fontSize: 64),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
```

---

## Praktikum 7: BLoC Pattern

### Soal Praktikum

**Soal 13:**

- Jelaskan maksud praktikum ini! Dimanakah letak konsep pola BLoC-nya?
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README.
- Lalu lakukan commit dengan pesan "**W12: Jawaban Soal 13**".

### Code Final

**random_bloc.dart:**

```dart
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
```

**random_screen.dart:**

```dart
import 'package:flutter/material.dart';
import 'random_bloc.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  late RandomNumberBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RandomNumberBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Pattern')),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data.toString(),
                style: const TextStyle(fontSize: 64),
              );
            } else {
              return const Text('Tekan tombol untuk generate');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.generateNumber(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---
