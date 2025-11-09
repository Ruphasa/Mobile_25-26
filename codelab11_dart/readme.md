---

# Laporan Jobsheet 11

## Pemrograman Asynchronous Flutter

### Identitas Praktikan

- **Nama :** Rizqi Fauzan
- **NIM :** 23417290143
- **Kelas :** TI-3H

---

## Praktikum 1

### 1. Membuat Project dan Kode Dasar

- Membuat project baru Flutter bernama **books** di folder **src week-11** repository GitHub Anda.
- Menambahkan dependency `http` pada `pubspec.yaml` dengan perintah berikut:
  ```
  flutter pub add http
  ```
- Pastikan file `pubspec.yaml` sudah menampilkan dependensi berikut:
  ```
  dependencies:
    flutter:
      sdk: flutter
    http: ^1.1.0
  ```

### 2. Source Code Praktikum

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back from the Future')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(child: const Text('GO!'), onPressed: () {}),
            const Spacer(),
            Text(result),
            const Spacer(),
            const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/i9PvStUdWz8C';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }
}
```

---

## Soal Praktikum

### Soal 1

Tambahkan **nama panggilan Anda** pada `title` app sebagai identitas hasil pekerjaan.

    return MaterialApp(
      title: 'Future Demo by Rizqi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FuturePage(),
    );

### Soal 2

- Cari judul buku favorit Anda di Google Books, lalu ganti ID buku pada variabel `path` di kode tersebut. Caranya ambil di URL browser seperti di instruksi praktikum.
- Akses URL tersebut di browser. Jika menampilkan data JSON, Anda sudah berhasil. Capture hasilnya dan masukkan ke README. Lakukan commit dengan pesan "**W11: Soal 2**".

```dart
  Future<Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/i9PvStUdWz8C';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }
```

### Soal 3

- Jelaskan maksud kode langkah 5 terkait penggunaan `substring` dan `catchError`!
  - substring digunakan untuk memotong
  - catch error fungsinya untuk menghandle jika ada error agar tidak hang/freeze atau terminated
- Capture hasil running aplikasi berupa GIF dan lampirkan di README.

## ![](img/praktikum1.gif)

Berikut adalah format **README/ laporan Praktikum 2** yang berisi khusus **class \_FuturePageState** (kode final yang diminta) dan **soal praktikum** (hanya soal 4 sesuai codelab):

---

# Laporan Praktikum 2

## Pemrograman Asynchronous Flutter — Await/Async

## Kode Class `_FuturePageState`

```dart
class _FuturePageState extends State<FuturePage> {
  String result = '';

  Future returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  void count() async {
    int  = await returnOneAsync();
    int two = await returnTwoAsync();
    int three = await returnThreeAsync();
    int sum = one + two + three;
    setState(() {
      result = sum.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back from the Future')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              child: const Text('GO!'),
              onPressed: () { count(); }
            ),
            const Spacer(),
            Text(result),
            const Spacer(),
            const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
```

---

## Soal Praktikum

**Soal 4:**
Buat function dalam class `_FuturePageState` yang sequential menggunakan async dan await sehingga:

- Method count akan memanggil fungsi `returnOneAsync`, `returnTwoAsync`, dan `returnThreeAsync` secara berurutan dengan perintah `await` menggunakan lama delay 3 detik masing-masing.
- Hasil penjumlahan ketiga fungsi tersebut disimpan ke dalam variabel hasil (`result`) dan dilakukan update ke UI dengan setState.

```dart
  void count() async {
    final results = await Future.wait<int>([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]);

    final sum = results.fold<int>(0, (prev, element) => prev + element);

    setState(() {
      result = sum.toString();
    });
  }
```

---

Berikut adalah format **README / Laporan Praktikum 3** sesuai kode original codelab, berisi kode utama dan soal praktikumnya.

---

# Laporan Praktikum 3

## Pemrograman Asynchronous Flutter — Future Completer

## Kode Final Praktikum 3

```dart
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
    return MaterialApp(
      title: 'Completer Demo',
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});
  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  late Completer completer;

  Future getNumber() {
    completer = Completer();
    calculate();
    return completer.future;
  }

  Future calculate() async {
    await Future.delayed(const Duration(seconds: 5));
    completer.complete(42);
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
                getNumber().then((value) {
                  setState(() {
                    result = value.toString();
                  });
                }).catchError((e) {
                  result = 'An error occurred';
                });
              }
            ),
            const SizedBox(height: 24),
            Text(result, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

---

## Soal Praktikum

**Soal:**
Soal 5

- Jelaskan maksud kode langkah 2 tersebut!
  Capture hasil praktikum Anda berupa GIF dan lampirkan di README. Lalu lakukan commit dengan pesan "W11: Soal 5".
!()[]

Soal 6

- Jelaskan maksud perbedaan kode langkah 2 dengan langkah 5-6 tersebut!
  Capture hasil praktikum Anda berupa GIF dan lampirkan di README. Lalu lakukan commit dengan pesan "W11: Soal 6".
![]()
---

Berikut adalah format **README / Laporan Praktikum 4** lengkap dengan kode final siap copy-paste dan soal praktikum:

***

# Laporan Praktikum 4  
## Pemrograman Asynchronous Flutter — Memanggil Future secara Paralel

***

## Kode main.dart

```dart
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
    return MaterialApp(
      title: 'FutureGroup Demo',
      home: const FuturePage(),
    );
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
                runParallel();
              }
            ),
            const SizedBox(height: 24),
            Text(result, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

***

## Soal Praktikum

### Soal 7
- Capture hasil praktikum Anda berupa GIF dan lampirkan di README. Lalu lakukan commit dengan pesan "**W11: Soal 7**".
![](img/)

### Soal 8
- Jelaskan maksud perbedaan kode pada langkah FutureGroup dengan kode pada Future.wait (lihat langkah 4 di materi praktikum)!
  - **Future.wait:**
    ```dart
    final futures = Future.wait([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]);
    ```
  - Jawaban perbedaan dapat langsung dituliskan pada README di bawah ini.
    - array yang berisikan future lebih dari satu. sehingga ketika array itu dijalankan maka isi yang lebih dari satu itu berjalan bersamaan



---

Reference : [codelab 11](https://jti-polinema.github.io/flutter-codelab/11-async)
