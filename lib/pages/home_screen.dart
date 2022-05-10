import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../auth/model/user_model.dart';
import '../auth/pref/user_preferences.dart';
import '../custom_screen/app_drawer.dart';
import '../custom_screen/text_feild_home.dart';
import '../utlies/app_colors.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = "homeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final MapController mapController = MapController();
  late User myuser;
  late final TextEditingController noBuildController;
  late final TextEditingController noRoadController;
  late final TextEditingController typeController;
  late final TextEditingController updateAreaController;
  String _fromCurrentItemSelected = "اختر";

  late final MapController _mapController;
  LocationData? _currentLocation;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;
  final Location _locationService = Location();

  List<LatLng> tappedPoints = [];
  List<Marker> allMarkers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapController = MapController();
    initLocationService();
    noBuildController = new TextEditingController();
    noRoadController = new TextEditingController();
    typeController = new TextEditingController();
    updateAreaController = new TextEditingController();
    myuser = UserPreferences.instance.getUser()!;
  }
  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
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

                // If Live Update is enabled, move map center
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
      currentLatLng = LatLng(0, 0);
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
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Column(children: [
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _serviceError!.isEmpty
                  ? Text('Live Location'
                  '(${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                  : Text(
                  'Error occured while acquiring location. Error Message : '
                      '$_serviceError'),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: AppColors.Drawer_COLOR, width: 1),
                  ),
                  child: Center(
                    child:FlutterMap(
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
                ),
            ),
          ]),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
      return FloatingActionButton(
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
      );
    }),
    );


  }

  // LocationButtonBuilder locationButton() {
  //   return (BuildContext context, ValueNotifier<LocationServiceStatus> status,
  //       Function onPressed) {
  //     return Align(
  //       alignment: Alignment.bottomRight,
  //       child: Padding(
  //         padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
  //         child: FloatingActionButton(
  //             child: ValueListenableBuilder<LocationServiceStatus>(
  //                 valueListenable: status,
  //                 builder: (BuildContext context, LocationServiceStatus value,
  //                     Widget? child) {
  //                   switch (value) {
  //                     case LocationServiceStatus.disabled:
  //                     case LocationServiceStatus.permissionDenied:
  //                     case LocationServiceStatus.unsubscribed:
  //                       return const Icon(
  //                         Icons.location_disabled,
  //                         color: Colors.white,
  //                       );
  //                     default:
  //                       return const Icon(
  //                         Icons.location_searching,
  //                         color: Colors.white,
  //                       );
  //                   }
  //                 }),
  //             onPressed: () => onPressed()),
  //       ),
  //     );
  //   };
  // }
}
