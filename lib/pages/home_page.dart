import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {

  static const String routeName = 'home';
  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {

    var markers = tappedPoints.map((latlng) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => Container(
          child: FlutterLogo(),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: buildDrawer(context, routeName),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  crs: const Epsg4326(),
                  center: LatLng(31.51, 34.45),
                  zoom: 15.0,


                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    // 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    'https://flutterapi.mogaza.org/public/wms900913.php?layer=cite:test_Rami&zoom={z}&TileCol={x}&TileRow={y}',
                    // subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: NonCachingNetworkTileProvider(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
