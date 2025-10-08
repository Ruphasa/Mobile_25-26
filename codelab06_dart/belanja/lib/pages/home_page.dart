import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';

class HomePage extends StatelessWidget {
  final List<Item> items = [
    Item(
      name: "Pensil",
      price: 2000,
      imageUrl: "images/pensil.png",
      stock: 50,
      rating: 4.5,
    ),
    Item(
      name: "Penghapus",
      price: 1000,
      imageUrl: "images/penghapus.png",
      stock: 30,
      rating: 4.2,
    ),
    Item(
      name: "Buku",
      price: 5000,
      imageUrl: "images/buku.png",
      stock: 20,
      rating: 4.8,
    ),
    Item(
      name: "Penggaris",
      price: 1500,
      imageUrl: "images/penggaris.png",
      stock: 40,
      rating: 4.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Belanja Barang')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dua kolom
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => ItemCard(item: items[index]),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blueGrey[50],
      alignment: Alignment.center,
      child: const Text("Nama: Rizqi Fauzan | NIM: 2341720143",
        style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
