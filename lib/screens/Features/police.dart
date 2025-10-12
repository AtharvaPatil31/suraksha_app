import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliceStationScreen extends StatefulWidget {
  const PoliceStationScreen({super.key});

  @override
  State<PoliceStationScreen> createState() => _PoliceStationScreenState();
}

class _PoliceStationScreenState extends State<PoliceStationScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final places = GoogleMapsPlaces(apiKey: "YOUR_API_KEY_HERE");

  LatLng? _nearestStationPosition;
  String? _nearestStationName;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _fetchNearbyPoliceStations(position.latitude, position.longitude);
  }

  Future<void> _fetchNearbyPoliceStations(double lat, double lng) async {
    final response = await places.searchNearbyWithRadius(
      Location(lat: lat, lng: lng),
      5000, // 5 km radius
      type: "police_station", // try "police_station" if results = 0
    );

    print("Places API status: ${response.status}, error: ${response.errorMessage}");
    print("Results found: ${response.results.length}");

    if (response.isOkay && response.results.isNotEmpty) {
      double minDistance = double.infinity;
      var nearestResult;

      for (var result in response.results) {
        LatLng stationPos = LatLng(
          result.geometry!.location.lat,
          result.geometry!.location.lng,
        );

        double distance = Geolocator.distanceBetween(
          lat,
          lng,
          stationPos.latitude,
          stationPos.longitude,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestResult = result;
          _nearestStationPosition = stationPos;
          _nearestStationName = result.name;
        }
      }

      setState(() {
        _markers.clear();

        // 🔹 User marker
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );

        // 🟢 Nearest police station marker
        if (nearestResult != null) {
          _markers.add(
            Marker(
              markerId: MarkerId(nearestResult.placeId),
              position: _nearestStationPosition!,
              infoWindow: InfoWindow(
                title: _nearestStationName!,
                snippet: "Tap to navigate",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              onTap: () {
                _openGoogleMaps(_nearestStationPosition!);
              },
            ),
          );

          // Move camera to show both points
          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  lat < _nearestStationPosition!.latitude ? lat : _nearestStationPosition!.latitude,
                  lng < _nearestStationPosition!.longitude ? lng : _nearestStationPosition!.longitude,
                ),
                northeast: LatLng(
                  lat > _nearestStationPosition!.latitude ? lat : _nearestStationPosition!.latitude,
                  lng > _nearestStationPosition!.longitude ? lng : _nearestStationPosition!.longitude,
                ),
              ),
              100,
            ),
          );
        }
      });
    }
  }

  Future<void> _openGoogleMaps(LatLng destination) async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=driving",
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearest Police Station"),
        backgroundColor: const Color(0xFF861FC0),
        foregroundColor: Colors.white,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
