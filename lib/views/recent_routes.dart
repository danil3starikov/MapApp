import 'package:flutter/material.dart' hide Route;
import 'package:map_app/database.dart';

class RecentRoutesView extends StatefulWidget {
  const RecentRoutesView({super.key});

  @override
  State<RecentRoutesView> createState() => _RecentRoutesViewState();
}

class _RecentRoutesViewState extends State<RecentRoutesView> {
  final AppDatabase db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Letzte Routen')),
      body: StreamBuilder(stream: db.watchRecentRoutes(),
       builder: (context, snapshot) {
          final routes = snapshot.data ?? [];
          
          if (routes.isEmpty) {
            return const Center(
              child: Text(
                'Keine Routen vorhanden',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

        return ListView.separated(
              itemCount: routes.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final route = routes[index];
                return ListTile(
                  leading: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.trip_origin, size: 16, color: Colors.grey),
                      Icon(Icons.more_vert, size: 12, color: Colors.grey),
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                    ],
                  ),
                  title: Text(
                    route.startLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  subtitle: Text(
                    route.destLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),                  ),
                );
              },
            );
      },
    ));
  }
}
