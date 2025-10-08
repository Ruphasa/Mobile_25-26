import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Wisata Gunung di Batu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Batu, Malang, Indonesia',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(context, Icons.call, 'CALL'),
        _buildButtonColumn(context, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(context, Icons.share, 'SHARE'),
      ],
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: const Text(
        'Gunung di Batu adalah salah satu destinasi wisata favorit di Malang. '
        'Area pegunungan yang asri dan sejuk, cocok untuk liburan dan keluarga.',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Flutter layout: Rizqi dan 2341720143',
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Flutter layout demo'),
        // ),
        body: ListView(
          children: [
            Image.asset(
              'images/gunung.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
      routes: {
        '/second': (context) => const SecondScreen(),
      },
    );
  }

  Column _buildButtonColumn(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Screen")),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
