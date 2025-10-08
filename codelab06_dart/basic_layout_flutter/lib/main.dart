import 'package:flutter/material.dart';

void main() => runApp(const SolarSystemApp());

class SolarSystemApp extends StatelessWidget {
  const SolarSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Solar System Layout',
      theme: ThemeData.dark(),
      home: const SolarSystemPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data sun + planet, nama & gambar & info singkat
const solarData = [
  {
    "name": "Sun",
    "image": "images/sun.jpeg",
    "info": "The center of Solar System\nType: G-type main-sequence star\nDiameter: 1,391,016 km"
  },
  {
    "name": "Mercury",
    "image": "images/mercury.jpeg",
    "info": "1st planet from the Sun\nDiameter: 4,879 km",
  },
  {
    "name": "Venus",
    "image": "images/venus.jpeg",
    "info": "2nd planet from the Sun\nDiameter: 12,104 km",
  },
  {
    "name": "Earth",
    "image": "images/earth.jpeg",
    "info": "3rd planet from the Sun\nDiameter: 12,742 km",
  },
  {
    "name": "Mars",
    "image": "images/mars.jpeg",
    "info": "4th planet from the Sun\nDiameter: 6,779 km",
  },
  {
    "name": "Jupiter",
    "image": "images/jupiter.jpeg",
    "info": "5th planet from the Sun\nDiameter: 139,820 km",
  },
  {
    "name": "Saturn",
    "image": "images/saturn.jpeg",
    "info": "6th planet from the Sun\nDiameter: 116,460 km",
  },
  {
    "name": "Uranus",
    "image": "images/uranus.jpeg",
    "info": "7th planet from the Sun\nDiameter: 50,724 km",
  },
  {
    "name": "Neptune",
    "image": "images/neptune.jpeg",
    "info": "8th planet from the Sun\nDiameter: 49,244 km",
  },
];

class SolarSystemPage extends StatefulWidget {
  const SolarSystemPage({super.key});

  @override
  State<SolarSystemPage> createState() => _SolarSystemPageState();
}

class _SolarSystemPageState extends State<SolarSystemPage> {
  int? selectedCelestial; // null jika tidak ada yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Solar System')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Matahari (sun)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedCelestial == 0) {
                    selectedCelestial = null;
                  } else {
                    selectedCelestial = 0;
                  }
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: selectedCelestial == 0 ? 84 : 68,
                    height: selectedCelestial == 0 ? 84 : 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          selectedCelestial == 0 ? Border.all(color: Colors.yellow, width: 5) : null,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 12,
                            spreadRadius: 4,
                            color: Colors.yellow.withOpacity(0.2))
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        solarData[0]["image"]!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                            color: Colors.orange,
                            child: const Icon(Icons.wb_sunny, color: Colors.white, size: 36)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    solarData[0]["name"]!,
                    style: TextStyle(
                        color: selectedCelestial == 0 ? Colors.yellow : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: selectedCelestial == 0 ? 19 : 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Barisan planet
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(solarData.length - 1, (i) {
                  final item = solarData[i + 1];
                  final index = i + 1;
                  final isSelected = selectedCelestial == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCelestial == index) {
                          selectedCelestial = null;
                        } else {
                          selectedCelestial = index;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: isSelected ? 58 : 48,
                            height: isSelected ? 58 : 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.white30,
                                          spreadRadius: 2)
                                    ]
                                  : [],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                item["image"]!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[700],
                                    child: const Icon(Icons.public, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["name"]!,
                            style: TextStyle(
                              color: isSelected ? Colors.amber : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                              fontSize: isSelected ? 15 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 28),
            // Card sun/planet aktif (hanya satu)
            if (selectedCelestial != null)
              CelestialDetailCard(
                celestial: solarData[selectedCelestial!],
                onClose: () => setState(() => selectedCelestial = null),
              ),
          ],
        ),
      ),
    );
  }
}

// Card universal untuk sun/planet
class CelestialDetailCard extends StatelessWidget {
  final Map<String, String> celestial;
  final VoidCallback onClose;
  const CelestialDetailCard({
    super.key,
    required this.celestial,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[900],
      elevation: 6,
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ListTile(
                  leading: ClipOval(
                    child: Image.asset(
                      celestial['image'] ?? "",
                      width: 36, height: 36, fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                          color: Colors.grey, child: const Icon(Icons.public, color: Colors.white)),
                    ),
                  ),
                  title: Text(celestial['name'] ?? "",
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                  subtitle: Text(
                    celestial['info']?.split('\n')[0] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                // Close button sudut kanan atas Card
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                celestial['info']?.split('\n').skip(1).join('\n') ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
