import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  NCameraPosition? cameraPosition;
  NaverMapController? controller;

  @override
  void initState() {
    super.initState();

    final data = Geolocator.getCurrentPosition().then((value) {
      print(value.heading);
      print(value.latitude);
      print(value.longitude);
    });
    print(data);

    _determinePosition();

    cameraPosition = NCameraPosition(
      target: NLatLng(startLat, startLng),
      zoom: 15,
      // bearing: 45,
      // tilt: 30,
    );
  }

  @override
  void dispose() {
    super.dispose();

    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: cameraPosition,
              // mapType: NMapType.navi,
              activeLayerGroups: [
                NLayerGroup.bicycle,
              ],
            ),
            onMapReady: (mapController) {
              controller = mapController;
              cameraPath();
            },
            onCameraChange: (position, reason) {
              print('position: ${position.name}');
            },
          ),
          Positioned(
            // right: 0,
            bottom: 0,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // await getPath();
                    cameraPath();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.yellow,
                    child: Text('길찾기'),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    moveCamera();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.yellow,
                    child: Text('카메라 조정'),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    FlutterCompass.events?.listen((event) {
                      print(event.heading);

                      controller?.updateCamera(
                        NCameraUpdate.withParams(
                          target: NLatLng(endLat, endLng),
                          bearing: event.heading,
                        ),
                      );
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.yellow,
                    child: Text('나침반'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final double startLat = 37.555848;
  final double startLng = 126.972311;
  final double endLat = 37.517234;
  final double endLng = 127.047611;

  Future<void> cameraPath() async {
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
        // coords: coordinates,
        coords: [NLatLng(startLat, startLng), NLatLng(endLat, endLng)],
      ),
    );
  }

  List<NLatLng> coordinates = [];

  Future<void> getPath() async {
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf624848ba941757374e1da01d94d7865bc499');

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
      profileOverride: ORSProfile.cyclingRoad,
    );

    routeCoordinates.forEach(print);

    routeCoordinates.forEach((coordinate) {
      coordinates.add(NLatLng(coordinate.latitude, coordinate.longitude));
    });
  }

  Future<void> moveCamera() async {
    var pattern = await NOverlayImage.fromWidget(
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

    controller?.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(endLat, endLng),
        bearingBy: 1,
      ),
    );

    controller?.addOverlay(
      NMarker(
        id: "test",
        position: NLatLng(endLat, endLng),
        icon: pattern,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
