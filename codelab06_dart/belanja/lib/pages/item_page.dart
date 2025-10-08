import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Item itemArgs = ModalRoute.of(context)!.settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(title: Text(itemArgs.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: itemArgs.name,
              child: Image.asset(itemArgs.imageUrl, width: 150),
            ),
            const SizedBox(height: 16),
            Text("Nama: ${itemArgs.name}", style: const TextStyle(fontSize: 20)),
            Text("Harga: Rp ${itemArgs.price}", style: const TextStyle(fontSize: 18)),
            Text("Stok: ${itemArgs.stock}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(itemArgs.rating.toString()),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Kembali'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
