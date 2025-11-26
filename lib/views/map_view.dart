import 'package:flutter/material.dart';
import 'package:atlas/atlas.dart';

class MapView extends StatefulWidget {
  final LatLng? startLatLng;
  final LatLng? destLatLng;
  const MapView({super.key, this.startLatLng, this.destLatLng});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  AtlasController? controller;
  
  void updateCameraPosition() {
    if (controller == null) return;

    if (widget.startLatLng != null && widget.destLatLng != null) {
      final route = MapRoute(
        start: widget.startLatLng!,
        end: widget.destLatLng!,
      );

      controller?.moveCamera(route.getCameraPosition());
    } else if (widget.startLatLng != null) {
      controller?.moveCamera(
        CameraPosition(target: widget.startLatLng!, zoom: 14),
      );
    } else if (widget.destLatLng != null) {
      controller?.moveCamera(
        CameraPosition(target: widget.destLatLng!, zoom: 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = LatLng(latitude: 37.422, longitude: -122.084);

    updateCameraPosition();
    return Atlas(
      onMapCreated: (ctrl) => controller = ctrl,
      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 12),
      mapType: MapType.normal,
      showMyLocation: true,
      showMyLocationButton: true,
      followMyLocation: FollowLocation.always,
      markers: {
        if (widget.startLatLng != null)
          Marker(id: 'start', position: widget.startLatLng!),
        if (widget.destLatLng != null)
          Marker(id: 'destination', position: widget.destLatLng!),
      },
      routes: {
        if (widget.startLatLng != null && widget.destLatLng != null)
          MapRoute(start: widget.startLatLng!, end: widget.destLatLng!),
      },
    );
  }
}
