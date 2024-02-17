import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';

Future<void> main() async {
  // Initialize the openrouteservice with your API key.
  final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf624848ba941757374e1da01d94d7865bc499');

  // Example coordinates to test between
  // const double startLat = 37.4220698;
  // const double startLng = -122.0862784;
  // const double endLat = 37.4111466;
  // const double endLng = -122.0792365;

  const double startLat = 37.534298;
  const double startLng = 126.987392;
  const double endLat = 37.534398;
  const double endLng = 126.986392;

  // Form Route between coordinates
  final List<ORSCoordinate> routeCoordinates =
      await client.directionsRouteCoordsGet(
    startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
    endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    profileOverride: ORSProfile.drivingCar,
  );

  // Print the route coordinates
  routeCoordinates.forEach(print);

  // Map route coordinates to a list of LatLng (requires google_maps_flutter package)
  // to be used in the Map route Polyline.
  final List<LatLng> routePoints = routeCoordinates
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();

  // Create Polyline (requires Material UI for Color)
  final Polyline routePolyline = Polyline(
    polylineId: PolylineId('route'),
    visible: true,
    points: routePoints,
    color: Colors.red,
    width: 4,
  );

  // 사이클
  // {latitude: 37.534271, longitude: 126.987357, altitude: 0.0}
  // {latitude: 37.533901, longitude: 126.987807, altitude: 0.0}
  // {latitude: 37.533662, longitude: 126.988148, altitude: 0.0}
  // {latitude: 37.533615, longitude: 126.988203, altitude: 0.0}
  // {latitude: 37.533744, longitude: 126.98825, altitude: 0.0}
  // {latitude: 37.533774, longitude: 126.988302, altitude: 0.0}
  // {latitude: 37.533781, longitude: 126.98837, altitude: 0.0}
  // {latitude: 37.533658, longitude: 126.988522, altitude: 0.0}
  // {latitude: 37.533632, longitude: 126.988586, altitude: 0.0}
  // {latitude: 37.533627, longitude: 126.988646, altitude: 0.0}
  // {latitude: 37.533876, longitude: 126.988372, altitude: 0.0}
  // {latitude: 37.534105, longitude: 126.988085, altitude: 0.0}
  // {latitude: 37.53415, longitude: 126.98783, altitude: 0.0}
  // {latitude: 37.5343, longitude: 126.98753, altitude: 0.0}
  // {latitude: 37.534571, longitude: 126.986992, altitude: 0.0}
  // {latitude: 37.534618, longitude: 126.986873, altitude: 0.0}
  // {latitude: 37.534407, longitude: 126.98687, altitude: 0.0}
  // {latitude: 37.534552, longitude: 126.986483, altitude: 0.0}

  // 자동차
  // {latitude: 37.534271, longitude: 126.987357, altitude: 0.0}
  // {latitude: 37.533901, longitude: 126.987807, altitude: 0.0}
  // {latitude: 37.533662, longitude: 126.988148, altitude: 0.0}
  // {latitude: 37.533615, longitude: 126.988203, altitude: 0.0}
  // {latitude: 37.533744, longitude: 126.98825, altitude: 0.0}
  // {latitude: 37.533774, longitude: 126.988302, altitude: 0.0}
  // {latitude: 37.533781, longitude: 126.98837, altitude: 0.0}
  // {latitude: 37.533658, longitude: 126.988522, altitude: 0.0}
  // {latitude: 37.533632, longitude: 126.988586, altitude: 0.0}
  // {latitude: 37.533627, longitude: 126.988646, altitude: 0.0}
  // {latitude: 37.533876, longitude: 126.988372, altitude: 0.0}
  // {latitude: 37.534105, longitude: 126.988085, altitude: 0.0}
  // {latitude: 37.53415, longitude: 126.98783, altitude: 0.0}
  // {latitude: 37.5343, longitude: 126.98753, altitude: 0.0}
  // {latitude: 37.534571, longitude: 126.986992, altitude: 0.0}
  // {latitude: 37.534726, longitude: 126.986597, altitude: 0.0}
  // Use Polyline to draw route on map or do anything else with the data :)
}
