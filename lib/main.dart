import 'package:flutter/material.dart';
import 'package:atlas/atlas.dart';
import 'package:google_atlas/google_atlas.dart';
import 'package:map_app/views/home_view.dart';
import 'package:map_app/views/recent_routes.dart';

void main() {
  AtlasProvider.instance = GoogleAtlas();

  runApp(const MapApp());
}

class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  int index = 0;
  final List<Widget> tabs = const [HomeView(), RecentRoutesView()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: index,
          children: tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Karte'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Verlauf',
            ),
          ],
        ),
      ),
    );
  }
}
