# Praktikum 14 - RESTful API

## Informasi Praktikum
- **Nama**: [Nama Anda]
- **NIM**: [NIM Anda]
- **Kelas**: [Kelas Anda]

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
flutter create pizza_api_[nama_anda]
cd pizza_api_[nama_anda]
```

#### 2. Tambahkan Dependensi HTTP
```bash
flutter pub add http
```

#### 3. Buat Model Pizza

**File: `lib/pizza.dart`**
```dart
class Pizza {
  int? id;
  String? pizzaName;
  String? description;
  double? price;
  String? imageUrl;

  Pizza({
    this.id,
    this.pizzaName,
    this.description,
    this.price,
    this.imageUrl,
  });

  // Constructor fromJson untuk deserialization
  Pizza.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pizzaName = json['pizzaName'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'];

  // Method toJson untuk serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pizzaName': pizzaName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
```

#### 4. Buat HTTP Helper

**File: `lib/httphelper.dart`**
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
import 'httphelper.dart';
import 'pizza.dart';
import 'pizza_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON [Nama Anda]', // Ganti dengan nama Anda
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Ganti sesuai selera
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
  Future<List<Pizza>> callPizzas() async {
    HttpHelper helper = HttpHelper();
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: callPizzas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> pizzas) {
          if (pizzas.hasError) {
            return const Text('Something went wrong');
          }
          if (!pizzas.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: (pizzas.data == null) ? 0 : pizzas.data!.length,
            itemBuilder: (BuildContext context, int position) {
              return Dismissible(
                key: Key(position.toString()),
                onDismissed: (direction) {
                  HttpHelper helper = HttpHelper();
                  pizzas.data!.removeWhere(
                      (element) => element.id == pizzas.data![position].id);
                  helper.deletePizza(pizzas.data![position].id!);
                },
                child: ListTile(
                  title: Text(pizzas.data![position].pizzaName ?? ''),
                  subtitle: Text(
                    '${pizzas.data![position].description ?? ''} - € ${pizzas.data![position].price?.toString() ?? '0'}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PizzaDetailScreen(
                          pizza: pizzas.data![position],
                          isNew: false,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PizzaDetailScreen(
                pizza: Pizza(),
                isNew: true,
              ),
            ),
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
[Masukkan screenshot di sini]

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

**File: `lib/pizza_detail.dart`** (FINAL)
```dart
import 'package:flutter/material.dart';
import 'pizza.dart';
import 'httphelper.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Pizza pizza;
  final bool isNew;

  const PizzaDetailScreen({
    super.key,
    required this.pizza,
    required this.isNew,
  });

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
  void initState() {
    if (!widget.isNew) {
      txtId.text = widget.pizza.id.toString();
      txtName.text = widget.pizza.pizzaName ?? '';
      txtDescription.text = widget.pizza.description ?? '';
      txtPrice.text = widget.pizza.price.toString();
      txtImageUrl.text = widget.pizza.imageUrl ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    super.dispose();
  }

  Future savePizza() async {
    HttpHelper helper = HttpHelper();
    Pizza pizza = Pizza(
      id: int.tryParse(txtId.text),
      pizzaName: txtName.text,
      description: txtDescription.text,
      price: double.tryParse(txtPrice.text),
      imageUrl: txtImageUrl.text,
    );

    final result = await (widget.isNew
        ? helper.postPizza(pizza)
        : helper.putPizza(pizza));
    
    setState(() {
      operationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Detail'),
      ),
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
                decoration: const InputDecoration(hintText: 'Insert Pizza Name'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(hintText: 'Insert Description'),
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
                  savePizza();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Penjelasan
- **POST** digunakan untuk mengirim data baru ke server
- Method `postPizza()` mengubah objek Pizza menjadi JSON menggunakan `json.encode()`
- `FloatingActionButton` di halaman utama untuk navigasi ke form input pizza baru
- `TextEditingController` digunakan untuk mengambil input dari user

### Soal 2
Screenshot/GIF aplikasi POST pizza:
[Masukkan screenshot/GIF di sini]

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
[Masukkan screenshot/GIF di sini]

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
     child: ListTile(...),
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
[Masukkan screenshot/GIF di sini]

---

## Ringkasan CRUD Operations

| Operation | HTTP Verb | Fungsi | Method |
|-----------|-----------|--------|--------|
| **Create** | POST | Menambah data baru | `postPizza()` |
| **Read** | GET | Mengambil data | `getPizzaList()` |
| **Update** | PUT | Memperbarui data | `putPizza()` |
| **Delete** | DELETE | Menghapus data | `deletePizza()` |

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
    return ListView.builder(...);
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

## Troubleshooting

### Error: "type 'List<dynamic>' is not a subtype of type 'List<Pizza>'"
**Solusi:** Gunakan type argument di method `map()`:
```dart
List<Pizza> pizzas = jsonResponse
    .map<Pizza>((i) => Pizza.fromJson(i))
    .toList();
```

### Error: "Could not connect to server"
**Solusi:** 
- Pastikan URL Mock API sudah benar
- Cek koneksi internet
- Pastikan stub sudah dibuat di Wire Mock Cloud

### Error: "Null check operator used on a null value"
**Solusi:**
- Gunakan null-safe operator (`?`, `??`, `!`)
- Pastikan semua field nullable di model Pizza

## Referensi
- Flutter HTTP Package: https://pub.dev/packages/http
- Wire Mock Cloud: https://www.wiremock.io/
- RESTful API Guide: https://restfulapi.net/
- Flutter Cookbook: https://docs.flutter.dev/cookbook

---

## Testing Checklist

- [ ] GET: Aplikasi berhasil menampilkan list pizza
- [ ] POST: Berhasil menambah pizza baru
- [ ] PUT: Berhasil mengupdate data pizza
- [ ] DELETE: Berhasil menghapus pizza dengan swipe
- [ ] Error handling berfungsi dengan baik
- [ ] Loading indicator muncul saat fetch data
- [ ] UI responsive dan user-friendly
