import 'package:flutter/material.dart';
import 'helper/httphelper.dart';
import 'models/pizza.dart';
import 'pages/pizza_detail.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPizzas();
  }

  Future<void> loadPizzas() async {
    setState(() {
      isLoading = true;
    });
    HttpHelper helper = HttpHelper();
    List<Pizza> pizzas = await helper.getPizzaList();
    setState(() {
      myPizzas = pizzas;
      isLoading = false;
    });
  }

  Future<List<Pizza>> callPizzas() async {
    HttpHelper helper = HttpHelper();
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PizzaDetailScreen(pizza: Pizza(), isNew: true, onSave: loadPizzas),
            ),
          );
        },
      ),
      appBar: AppBar(title: const Text('JSON')),
      body: isLoading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: myPizzas.length,
              itemBuilder: (BuildContext context, int position) {
                return Dismissible(
                  key: Key(myPizzas[position].id.toString()),
                  onDismissed: (item) async {
                    int pizzaId = myPizzas[position].id!;
                    setState(() {
                      myPizzas.removeAt(position);
                    });
                    HttpHelper helper = HttpHelper();
                    await helper.deletePizza(pizzaId);
                  },
                  child: ListTile(
                    title: Text(myPizzas[position].pizzaName ?? ''),
                    subtitle: Text(
                      (myPizzas[position].description ?? '') +
                          ' - € ' +
                          (myPizzas[position].price?.toString() ?? ''),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PizzaDetailScreen(
                            pizza: myPizzas[position],
                            isNew: false,
                            onSave: loadPizzas,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
