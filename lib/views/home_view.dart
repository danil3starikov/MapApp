import 'package:atlas/atlas.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:map_app/network/network_utility.dart';
import 'package:map_app/network/place_autocomplete_response.dart';
import 'package:map_app/views/map_view.dart';
import 'package:map_app/components/swap_button.dart';
import 'package:map_app/components/custom_text_field.dart';
import 'package:map_app/database.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Controllers for text fields
  final TextEditingController startController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  // Selected locations and their coordinates
  String? selectedStartLocation;
  String? selectedDestLocation;
  LatLng? startLatLng;
  LatLng? destLatLng;

  // For managing the search
  bool isSearchingForStart = false;
  List<AutocompletePrediction> placePredictions = [];

  late AppDatabase db;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
  }

  @override
  void dispose() {
    startController.dispose();
    destController.dispose();
    super.dispose();
  }

  Future<void> saveRoute() async {
    if (selectedStartLocation != null && selectedDestLocation != null) {
      await db.addRoute(selectedStartLocation!, selectedDestLocation!);
    }
  }

  Future<void> selectLocation(String location) async {
    final prediction = placePredictions.firstWhere(
      (prediction) => prediction.description == location,
      orElse: () => AutocompletePrediction(),
    );

    setState(() {
      if (isSearchingForStart) {
        selectedStartLocation = location;
        startController.text = location;
      } else {
        selectedDestLocation = location;
        destController.text = location;
      }
      placePredictions.clear();
    });

    // Fetch coordinates if placeId exists
    if (prediction.placeId != null) {
      await NetworkUtility.fetchPlaceDetails(prediction.placeId!).then((
        latLng,
      ) {
        setState(() {
          if (isSearchingForStart) {
            startLatLng = latLng;
          } else {
            destLatLng = latLng;
          }
        });

        // Save the route once both start and end locations are input
        if (startLatLng != null && destLatLng != null) {
          saveRoute();
        }
      });
    }
  }

  void onSwapLocations() {
    setState(() {
      final temp = startController.text;
      startController.text = destController.text;
      destController.text = temp;

      final tempLocation = selectedStartLocation;
      selectedStartLocation = selectedDestLocation;
      selectedDestLocation = tempLocation;

      final tempLatLng = startLatLng;
      startLatLng = destLatLng;
      destLatLng = tempLatLng;
    });
  }

  void onTextFieldTap(bool isStart) {
    setState(() {
      isSearchingForStart = isStart;
    });
  }

  void onTextFieldChanged(String value, bool isStart) {
    setState(() {
      isSearchingForStart = isStart;
      placePredictions.clear();
    });

    NetworkUtility.fetchSuggestions(value, isStart).then((predictions) {
      setState(() {
        placePredictions = predictions ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 70,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.radio_button_checked,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                    const Icon(Icons.location_on, size: 24, color: Colors.red),
                  ],
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Startpunkt wählen",
                        controller: startController,
                        onTap: () => onTextFieldTap(true),
                        onChanged: (value) => onTextFieldChanged(value, true),
                        onDelete: () {
                          setState(() {
                            startController.clear();
                            selectedStartLocation = null;
                            startLatLng = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Reiseziel eingeben",
                        controller: destController,
                        onTap: () => onTextFieldTap(false),
                        onChanged: (value) => onTextFieldChanged(value, false),
                        onDelete: () {
                          setState(() {
                            destController.clear();
                            selectedDestLocation = null;
                            destLatLng = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                SwapButton(onTap: onSwapLocations),
              ],
            ),
          ),

          Expanded(
            flex: 10,
            child: Stack(
              children: [
                MapView(startLatLng: startLatLng, destLatLng: destLatLng),

                if (placePredictions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) {
                        final prediction = placePredictions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          textColor: Colors.black,
                          title: Text(prediction.description ?? ''),
                          onTap: () {
                            selectLocation(prediction.description ?? '');
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
