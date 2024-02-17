// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:open_route_test/main_view_model.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final vm = MainViewModel();
  NaverMapController? controller;
  StreamSubscription<Position>? posListener;
  StreamSubscription<CompassEvent>? compassListener;
  Position? position;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    super.dispose();

    controller?.dispose();
    posListener?.cancel();
    compassListener?.cancel();
  }

  Future<void> init() async {
    final posStream = await vm.determinePosition();

    posListener = posStream.listen((pos) {
      position = pos;
    });

    compassListener = FlutterCompass.events?.listen((bearing) {
      if (position != null && bearing.heading != null) {
        moveCamera(bearing: bearing.heading!, position: position!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              // initialCameraPosition: cameraPosition,
              activeLayerGroups: [
                NLayerGroup.bicycle,
              ],
            ),
            onMapReady: (mapController) {
              controller = mapController;
              // drawPath();
            },
            onCameraChange: (position, reason) {
              // print('position: ${position.name}');
            },
          ),
          Positioned(
            // right: 0,
            bottom: 0,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    getPath().then((paths) => drawPath(paths));
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.yellow,
                    child: Text('길찾기'),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final double startLat = 37.555848;
  final double startLng = 126.972311;
  final double endLat = 37.517234;
  final double endLng = 127.047611;

  Future<void> drawPath(List<NLatLng> coordinates) async {
    var pattern = await NOverlayImage.fromWidget(
      widget: Icon(
        Icons.keyboard_arrow_up,
        size: 20,
        color: Colors.white,
      ),
      size: Size(20, 20),
      context: context,
    );

    controller?.addOverlay(
      NPathOverlay(
        outlineColor: Colors.white,
        color: Colors.lightBlue,
        passedColor: Colors.black,
        patternImage: pattern,
        outlineWidth: 3,
        width: 8,
        id: 'test',
        coords: coordinates,
        // coords: [
        //   NLatLng(startLat, startLng),
        //   NLatLng(endLat, endLng),
        // ],
      ),
    );
  }

  Future<List<NLatLng>> getPath() async {
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf624848ba941757374e1da01d94d7865bc499');

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      // startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
      // endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
      startCoordinate: ORSCoordinate(
        latitude: position!.latitude,
        longitude: position!.longitude,
      ),
      endCoordinate: ORSCoordinate(
        latitude: position!.latitude + 0.01,
        longitude: position!.longitude + 0.01,
      ),
      profileOverride: ORSProfile.cyclingRoad,
    );

    routeCoordinates.forEach(print);

    List<NLatLng> coordinates = [];
    routeCoordinates.forEach((coordinate) {
      coordinates.add(NLatLng(coordinate.latitude, coordinate.longitude));
    });

    return coordinates;
  }

  Future<void> moveCamera({
    required Position position,
    required double bearing,
  }) async {
    var icon = await getCurrentPositionImage();

    final target = NLatLng(position.latitude, position.longitude);

    controller?.updateCamera(
      NCameraUpdate.withParams(
        zoom: 15,
        target: target,
        bearing: bearing,
      ),
    );

    controller?.addOverlay(
      NMarker(
        id: "test",
        position: target,
        icon: icon,
      ),
    );
  }

  Future<NOverlayImage> getCurrentPositionImage() async {
    return await NOverlayImage.fromWidget(
      widget: Stack(
        children: [
          Icon(
            Icons.circle,
            size: 20,
            color: Colors.red,
          ),
          Icon(
            Icons.keyboard_arrow_up_outlined,
            size: 20,
            color: Colors.black,
          ),
        ],
      ),
      size: Size(20, 20),
      context: context,
    );
  }
}
