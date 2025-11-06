Berikut README/laporan praktikum sesuai permintaan—**tanpa bagian kesimpulan dan penjelasan, serta sudah memasukkan soal praktikum**:

***

# Laporan Praktikum 1  
## Pemrograman Asynchronous Flutter

### Identitas Praktikan
- **Nama  :** Rizqi Fauzan
- **NIM   :** 23417290143
- **Kelas :** TI-3H

***

## Langkah Praktikum

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

***

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

![](img/praktikum1.gif)
---

[Codelab Praktikum 1](https://jti-polinema.github.io/flutter-codelab/11-async/#2)