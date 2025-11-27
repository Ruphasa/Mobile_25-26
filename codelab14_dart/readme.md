# Praktikum 14 - RESTful API

## Informasi Praktikum

- **Nama**: Rizqi Fauzan
- **NIM**: 2341720143
- **Kelas**: TI-3H

---

## Praktikum 1: Membuat Layanan Mock API

### Tujuan

Membuat aplikasi Flutter yang dapat mengambil data dari web service menggunakan HTTP GET request.

### Persiapan Mock API

1. **Daftar ke Wire Mock Cloud**

   - Buka [https://app.wiremock.cloud/](https://app.wiremock.cloud/)
   - Buat akun dan login

2. **Setup Stub untuk GET Pizza List**

   - Buka "Example Mock API" → Stubs
   - Klik "New" untuk membuat stub baru
   - Isi dengan data berikut:
     - **Name**: Pizza List
     - **Verb**: GET
     - **Address**: /pizzalist
     - **Status**: 200
     - **Body Type**: JSON
     - **Body**: Gunakan data dari [https://bit.ly/pizzalist](https://bit.ly/pizzalist)
   - Klik **Save**

3. **Catat Mock API URL**
   - Anda akan mendapatkan URL seperti: `xxxxx.mocklab.io`
   - URL ini akan digunakan di kode Flutter

### Langkah-langkah

#### 1. Buat Project Flutter Baru

```bash
flutter create pizza_api_rizqi
cd pizza_api_rizqi
```

#### 2. Tambahkan Dependensi HTTP

```bash
flutter pub add http
```

#### 3. Buat HTTP Helper

**File: `lib/helper/httphelper.dart`**

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pizza.dart';

class HttpHelper {
  // Singleton pattern
  static final HttpHelper _httpHelper = HttpHelper._internal();
  HttpHelper._internal();
  factory HttpHelper() {
    return _httpHelper;
  }

  // Ganti dengan URL Mock API Anda
  final String authority = 'xxxxx.mocklab.io'; // GANTI DENGAN URL ANDA
  final String path = 'pizzalist';

  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      // Provide a type argument to the map method to avoid type error
      List<Pizza> pizzas = jsonResponse
          .map<Pizza>((i) => Pizza.fromJson(i))
          .toList();
      return pizzas;
    } else {
      return [];
    }
  }

  Future<String> postPizza(Pizza pizza) async {
    const postPath = '/pizza';
    String post = json.encode(pizza.toJson());
    Uri url = Uri.https(authority, postPath);
    http.Response r = await http.post(
      url,
      body: post,
    );
    return r.body;
  }

  Future<String> putPizza(Pizza pizza) async {
    const putPath = '/pizza';
    String put = json.encode(pizza.toJson());
    Uri url = Uri.https(authority, putPath);
    http.Response r = await http.put(
      url,
      body: put,
    );
    return r.body;
  }

  Future<String> deletePizza(int id) async {
    const deletePath = '/pizza';
    Uri url = Uri.https(authority, deletePath);
    http.Response r = await http.delete(url);
    return r.body;
  }
}
```

#### 5. Edit Main.dart

**File: `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'helper/httphelper.dart';
import 'models/pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Rizqi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ), // Ganti sesuai selera
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JSON'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pizza> myPizzas = [];

  Future<List<Pizza>> callPizzas() async {
    HttpHelper helper = HttpHelper();
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON')),
      body: FutureBuilder(
        future: callPizzas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: (snapshot.data == null) ? 0 : snapshot.data!.length,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                title: Text(snapshot.data![position].pizzaName),
                subtitle: Text(
                  snapshot.data![position].description +
                      ' - € ' +
                      snapshot.data![position].price.toString(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Soal 1

✅ Nama panggilan ditambahkan pada `title` app
✅ Warna tema aplikasi disesuaikan

Screenshot hasil aplikasi:
![](img/praktikum%201.gif)

**Penjelasan Singleton Pattern:**
Singleton pattern memastikan bahwa hanya ada satu instance dari `HttpHelper` di seluruh aplikasi. Ini menghemat resource dan menghindari pembuatan objek yang berulang-ulang.

---

## Praktikum 2: Mengirim Data ke Web Service (POST)

### Tujuan

Mengirim data baru ke web service menggunakan HTTP POST request.

### Persiapan Mock API

1. **Setup Stub untuk POST Pizza**
   - Buka Wire Mock Cloud → Stubs → New
   - Isi dengan data berikut:
     - **Name**: Post Pizza
     - **Verb**: POST
     - **Address**: /pizza
     - **Status**: 201
     - **Body Type**: JSON
     - **Body**: `{"message": "The pizza was posted"}`
   - Klik **Save**

### File yang Dibuat

**File: `lib/pizza_detail.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:pizza_api_rizqi/models/pizza.dart';
import 'package:pizza_api_rizqi/helper/httphelper.dart';

class PizzaDetailScreen extends StatefulWidget {
  const PizzaDetailScreen({super.key});
  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  String operationResult = '';

  @override
  void dispose() {
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pizza Detail')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                operationResult,
                style: TextStyle(
                  backgroundColor: Colors.green[200],
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtId,
                decoration: const InputDecoration(hintText: 'Insert ID'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtName,
                decoration: const InputDecoration(
                  hintText: 'Insert Pizza Name',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(
                  hintText: 'Insert Description',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtPrice,
                decoration: const InputDecoration(hintText: 'Insert Price'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtImageUrl,
                decoration: const InputDecoration(hintText: 'Insert Image Url'),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                child: const Text('Send Post'),
                onPressed: () {
                  postPizza();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future postPizza() async {
    HttpHelper helper = HttpHelper();
    Pizza pizza = Pizza();
    pizza.id = int.tryParse(txtId.text);
    pizza.pizzaName = txtName.text;
    pizza.description = txtDescription.text;
    pizza.price = double.tryParse(txtPrice.text);
    pizza.imageUrl = txtImageUrl.text;
    String result = await helper.postPizza(pizza);
    setState(() {
      operationResult = result;
    });
  }
}

```

**File: `lib/main.dart`**

```dart
floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PizzaDetailScreen()),
          );
        },
      ),
```

### Penjelasan

- **POST** digunakan untuk mengirim data baru ke server
- Method `postPizza()` mengubah objek Pizza menjadi JSON menggunakan `json.encode()`
- `FloatingActionButton` di halaman utama untuk navigasi ke form input pizza baru
- `TextEditingController` digunakan untuk mengambil input dari user

### Soal 2

Screenshot/GIF aplikasi POST pizza:
![](img/praktikum%202.gif)

**Field tambahan yang bisa ditambahkan:**

- `category` (String): Kategori pizza (e.g., "Vegetarian", "Meat Lovers")
- `rating` (double): Rating pizza (0.0 - 5.0)
- `available` (bool): Ketersediaan pizza

---

## Praktikum 3: Memperbarui Data di Web Service (PUT)

### Tujuan

Memperbarui data yang sudah ada di web service menggunakan HTTP PUT request.

### Persiapan Mock API

1. **Setup Stub untuk PUT Pizza**
   - Buka Wire Mock Cloud → Stubs → New
   - Isi dengan data berikut:
     - **Name**: Put Pizza
     - **Verb**: PUT
     - **Address**: /pizza
     - **Status**: 200
     - **Body Type**: JSON
     - **Body**: `{"message": "Pizza was updated"}`
   - Klik **Save**

### Perubahan File

Semua perubahan sudah terintegrasi dalam file `pizza_detail.dart` dan `main.dart` di atas.

**Poin Penting:**

1. **Di `pizza_detail.dart`:**

   - Constructor menerima parameter `pizza` dan `isNew`
   - Method `initState()` mengisi TextField jika `isNew = false`
   - Method `savePizza()` menggunakan conditional untuk POST atau PUT

   ```dart
   Future savePizza() async {
    HttpHelper helper = HttpHelper();
    Pizza pizza = Pizza();
    pizza.id = int.tryParse(txtId.text);
    pizza.pizzaName = txtName.text;
    pizza.description = txtDescription.text;
    pizza.price = double.tryParse(txtPrice.text);
    pizza.imageUrl = txtImageUrl.text;
    final result = await (widget.isNew
        ? helper.postPizza(pizza)
        : helper.putPizza(pizza));
    setState(() {
      operationResult = result;
    });
   }
   ```

2. **Di `main.dart`:**

   - `onTap` pada ListTile navigasi ke PizzaDetailScreen dengan `isNew: false`
   - FloatingActionButton navigasi ke PizzaDetailScreen dengan `isNew: true`

3. **Di `httphelper.dart`:**
   - Method `putPizza()` sudah ditambahkan (lihat kode lengkap di Praktikum 1)

### Cara Kerja

- Ketika user tap pada ListTile pizza yang sudah ada, aplikasi akan:
  1. Navigasi ke PizzaDetailScreen
  2. Mengisi form dengan data pizza yang dipilih
  3. User bisa mengedit data
  4. Ketika klik "Send Post", akan memanggil `putPizza()` karena `isNew = false`

### Soal 3

Screenshot/GIF aplikasi UPDATE pizza dengan Nama dan NIM:
![](img/praktikum%203.gif)

**Contoh data yang diupdate:**

```
ID: 1
Pizza Name: Margherita - [Nama Anda]
Description: [NIM Anda] - Pizza with tomato and mozzarella
Price: 10.50
Image URL: images/margherita.png
```

---

## Praktikum 4: Menghapus Data dari Web Service (DELETE)

### Tujuan

Menghapus data dari web service menggunakan HTTP DELETE request dengan gesture swipe.

### Persiapan Mock API

1. **Setup Stub untuk DELETE Pizza**
   - Buka Wire Mock Cloud → Stubs → New
   - Isi dengan data berikut:
     - **Name**: Delete Pizza
     - **Verb**: DELETE
     - **Address**: /pizza
     - **Status**: 200
     - **Body Type**: JSON
     - **Body**: `{"message": "Pizza was deleted"}`
   - Klik **Save**

### Perubahan File

Semua perubahan sudah terintegrasi dalam `main.dart` (lihat kode lengkap di Praktikum 1).

**Poin Penting:**

1. **Widget Dismissible:**

   ```dart
   Dismissible(
     key: Key(position.toString()),
     onDismissed: (direction) {
       HttpHelper helper = HttpHelper();
       pizzas.data!.removeWhere(
           (element) => element.id == pizzas.data![position].id);
       helper.deletePizza(pizzas.data![position].id!);
     },
     child: ListTile(
      ...
      ),
   )
   ```

2. **Method deletePizza() di httphelper.dart:**
   - Sudah ditambahkan di kode lengkap Praktikum 1
   - Menerima parameter `id` untuk menentukan pizza yang akan dihapus

### Cara Kerja

- User swipe (geser) ListTile ke kiri atau kanan
- Widget `Dismissible` akan mendeteksi gesture
- Callback `onDismissed` akan:
  1. Menghapus data dari list lokal menggunakan `removeWhere()`
  2. Memanggil `helper.deletePizza()` untuk menghapus di server
- ListTile akan hilang dari tampilan dengan animasi

### Soal 4

Screenshot/GIF aplikasi DELETE pizza (swipe gesture):
![](img/praktikum%204.gif)
---

## Ringkasan CRUD Operations

| Operation  | HTTP Verb | Fungsi             | Method           |
| ---------- | --------- | ------------------ | ---------------- |
| **Create** | POST      | Menambah data baru | `postPizza()`    |
| **Read**   | GET       | Mengambil data     | `getPizzaList()` |
| **Update** | PUT       | Memperbarui data   | `putPizza()`     |
| **Delete** | DELETE    | Menghapus data     | `deletePizza()`  |

## Catatan Penting

### 1. Singleton Pattern di HttpHelper

```dart
static final HttpHelper _httpHelper = HttpHelper._internal();
HttpHelper._internal();
factory HttpHelper() {
  return _httpHelper;
}
```

- Memastikan hanya ada satu instance HttpHelper
- Menghemat resource dan memory
- Mudah diakses dari berbagai bagian aplikasi

### 2. FutureBuilder

```dart
FutureBuilder(
  future: callPizzas(),
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error');
    if (!snapshot.hasData) return CircularProgressIndicator();
    return ListView.builder(
      ...
    );
  },
)
```

- Menangani operasi asynchronous
- Menampilkan loading indicator saat data belum tersedia
- Error handling yang baik

### 3. Dismissible Widget

- Memberikan interaksi swipe-to-delete
- Animasi built-in yang smooth
- Callback `onDismissed` untuk aksi setelah swipe