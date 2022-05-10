import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/auth/model/user_model.dart';
import 'package:flutter_map_example/auth/pref/user_preferences.dart';
import 'package:flutter_map_example/custom_screen/app_drawer.dart';
import 'package:flutter_map_example/custom_screen/text_feild_home.dart';
import 'package:flutter_map_example/utlies/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../widgets/drawer.dart';

class LiveLocationPage extends StatefulWidget {
  static const String routeName = '/live_location';

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {

  late User myuser;
  late final TextEditingController noBuildController;
  late final TextEditingController noRoadController;
  late final TextEditingController typeController;
  late final TextEditingController updateAreaController;
  String _fromCurrentItemSelected = "اختر";

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;
  final List<_PositionItem> _positionItems = <_PositionItem>[];

  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  List<LatLng> tappedPoints = [];
  List<Marker> allMarkers = [];
  late LatLng _center ;
  late Position currentLocation;

  @override
  void initState() {
    super.initState();
    // _getCurrentPosition();
    _mapController = MapController();
    initLocationService();
    getUserLocation();
    _liveUpdate = true;
    noBuildController = new TextEditingController();
    noRoadController = new TextEditingController();
    typeController = new TextEditingController();
    updateAreaController = new TextEditingController();
    myuser = UserPreferences.instance.getUser()!;
  }

  Future<Position> locateUser() async {
    return Geolocator
        .getCurrentPosition();
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    print('center $_center');
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      ));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  void initLocationService() async {
    await _locationService.changeSettings(
      //accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                /// /// ///
                //If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(31.506625, 34.460027);
    }

    allMarkers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: currentLatLng,
        builder: (context) => const Icon(
          Icons.my_location,
          color: Colors.blueAccent,
          size: 35.0,
         ),
        ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "مستكشف المدينة",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 0,
      ),
      drawer: DrawerScreen(),
      // drawer: buildDrawer(context, LiveLocationPage.route),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 36, right: 36, top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.add_road,
                                color: AppColors.MAIN_COLOR,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "رقم المبنى",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                      color: AppColors.MAIN_COLOR),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: HomeTextField(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              textEditingController: noBuildController,
                              hintTextKey: "12",
                              validateFunction: () {},
                              saveFunction: () {},
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child:  Row(
                            children: const [
                              Icon(
                                Icons.confirmation_num_sharp,
                                color: AppColors.MAIN_COLOR,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "رقم الشارع",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                      color: AppColors.MAIN_COLOR),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: HomeTextField(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              textEditingController: noRoadController,
                              hintTextKey: "12",
                              validateFunction: () {},
                              saveFunction: () {},
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.thirteen_mp,
                                color: AppColors.MAIN_COLOR,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "النوع",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                      color: AppColors.MAIN_COLOR),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Center(
                              child: HomeTextField(
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                textEditingController: typeController,
                                hintTextKey: "12",
                                validateFunction: () {},
                                saveFunction: () {},
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            color: Colors.white,
            padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: AppColors.Back_Ground_COLOR,
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        style: Theme.of(context).textTheme.headline6,
                        disabledHint: Center(child: Text("اختر", textAlign: TextAlign.center,)),
                        value: _fromCurrentItemSelected,
                        dropdownColor: Colors.grey.shade200,
                        alignment: AlignmentDirectional.centerStart,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: AppColors.MAIN_COLOR,
                        ),
                        items: myuser.termsOfReference!.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _fromCurrentItemSelected = v!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 30,
                      color: AppColors.MAIN_COLOR,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.MAIN_COLOR,
                    ),
                    child:const Center(
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "تحديث الموقع",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(child: Container(
          // )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: _serviceError!.isEmpty
                        ? Text('This is a map that is showing '
                            '(${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                        : Text(
                            'Error occured while acquiring location. Error Message : '
                            '$_serviceError'),
                  ),
                  Flexible(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        // center:  LatLng(currentLatLng.latitude, currentLatLng.longitude),
                        crs: const Epsg4326(),
                        // center: LatLng(31.51, 34.45),
                        zoom: 15.0,
                        interactiveFlags: interActiveFlags,

                        onTap: (tapPosition, p) => setState(() async {

                          allMarkers.clear();

                          allMarkers.add(
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: p,
                              builder: (context) => const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 35.0,
                              ),
                            ),

                          );

                          Response response;
                          var dio = Dio();

                           response = await dio.post('https://flutterapi.mogaza.org/public/api/GetBuildingData', data: {'x': p.longitude, 'y':p.latitude} );

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response.data.toString()),
                          ));
                        }),

                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                          //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          // subdomains: ['a', 'b', 'c'],
                          'https://flutterapi.mogaza.org/public/wms900913.php?layer=cite:test_Rami&zoom={z}&TileCol={x}&TileRow={y}',
                          // For example purposes. It is recommended to use
                          // TileProvider with a caching and retry strategy, like
                          // NetworkTileProvider or CachedNetworkTileProvider
                          tileProvider: NonCachingNetworkTileProvider(),
                        ),
                        MarkerLayerOptions(markers: allMarkers)

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Builder(builder: (BuildContext context) {
        return Column(
          children: [
            Spacer(),
            // FloatingActionButton(
            //   child: (_positionStreamSubscription == null ||
            //       _positionStreamSubscription!.isPaused)
            //       ? const Icon(Icons.play_arrow)
            //       : const Icon(Icons.pause),
            //   onPressed: () {
            //     positionStreamStarted = !positionStreamStarted;
            //     _toggleListening();
            //   },
            //   tooltip: (_positionStreamSubscription == null)
            //       ? 'Start position updates'
            //       : _positionStreamSubscription!.isPaused
            //       ? 'Resume'
            //       : 'Pause',
            //   backgroundColor: _determineButtonColor(),
            // ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _liveUpdate = !_liveUpdate;

                  if (_liveUpdate) {
                    interActiveFlags = InteractiveFlag.rotate |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom;

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'In live update mode only zoom and rotation are enable'),
                    ));
                  } else {
                    interActiveFlags = InteractiveFlag.all;
                  }
                });
              },
              child:
                  _liveUpdate ? Icon(Icons.location_on) : Icon(Icons.location_off),
            ),
          ],
        );
      }),
    );
  }


}
enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
