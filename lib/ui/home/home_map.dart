import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/providers/recently_added_products_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/shared_preferences/shared_preferences_helper.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/custom_widgets/product_item/product_item.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item_fav.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';


class HomeMap extends StatefulWidget {
  HomeMap({Key key, this.title, this.callback}) : super(key: key);

  final String title;
  VoidCallback callback;




  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> with TickerProviderStateMixin {
  static final LatLng _center = const LatLng(0, 0);

  double _height = 0, _width = 0;
  bool _infoWindow = false;

  AnimationController _animationController;
  HomeProvider _homeProvider;
  AuthProvider _authProvider;
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  PageController _pageController = PageController();
  MarkerId previousMarker;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController googleMapController;
  MarkersListFeeder markersListFeeder = MarkersListFeeder();

  String _lat, _long, _lang;
  int count = 0, _markerId;
  bool _initialRun = true;
  Future<void> _getCurrentLatitude() async {
    String _currentLat = await SharedPreferencesHelper.getUserlat();

    setState(() {
      _lat = _currentLat;
    });
  }

  Future<void> _getCurrentLongitude() async {
    String _currentLong = await SharedPreferencesHelper.getUserlong();
    setState(() {
      _long = _currentLong;
    });
  }

  Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    setState(() {
      _lang = currentLang ;
    });
  }






  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _authProvider = Provider.of<AuthProvider>(context);
      _getCurrentLatitude();
      _getCurrentLongitude();
      _getLanguage();

      _addMarkers();
      _animationController = AnimationController(
          duration: Duration(milliseconds: 2000), vsync: this);

      _initialRun = false;

    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String img = 'assets/images/marker.png';
  String img2 = 'assets/images/active_marker.png';

  BitmapDescriptor pinLocationIcon0;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinLocationIcon1;

  void _highlightMaker(MarkerId markerId) async {

        pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5.0), img);

    pinLocationIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5.0), img2);

    // select marker by id
    final Marker marker = markers[markerId];

    if (marker != null) {
      setState(() {
        if (previousMarker != null) {
          final Marker resetOld =
              markers[previousMarker].copyWith(iconParam: pinLocationIcon);
          markers[previousMarker] = resetOld;
           pinLocationIcon0 =pinLocationIcon;
        }

        // update the selected marker by changing the icon using copyWith() helper method
        final Marker newMarker = marker.copyWith(iconParam: pinLocationIcon1);

        markers[markerId] = newMarker;
        previousMarker = newMarker.markerId;

        print(newMarker.markerId);

        setState(() {
          _infoWindow = true;
          
        });

        // zoom in to the selected camera position
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: newMarker.position,
            zoom: 15.0,
          ),
        ));
      });
    }
  }

  _hideListView()async{
    pinLocationIcon0 = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 5.0), img);
    String id = 'markerId$_markerId';
     final MarkerId markerId = MarkerId(id);
    final Marker marker = markers[markerId];
    final Marker newMarker = marker.copyWith(iconParam: pinLocationIcon0);
    setState(() {
      _infoWindow = false;
           //   previousMarker = newMarker.markerId;
           markers[markerId] = newMarker;
    });
    
     
  }

  _addMarkers() async {
    final _dataSnapShot = _homeProvider.enableSearch?await markersListFeeder.getAllMarkersListSearch(_homeProvider.selectedCity!=null?_homeProvider.selectedCity.cityId:'',_homeProvider.selectedCategory1!=null?_homeProvider.selectedCategory1.catId:'',_homeProvider.searchKey!=null?_homeProvider.searchKey:'',_homeProvider.currentUserRate!=null?_homeProvider.currentUserRate:''):await markersListFeeder.getAllMarkersList();
    print(_dataSnapShot.length);
    print("Ssssssssssssssssssssss");
    if (_dataSnapShot.length == null) {
      _dataSnapShot.length = 0;
    }
    BitmapDescriptor pinDefaultIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 10.0), 'assets/images/marker.png');
    for (int i = 0; i < _dataSnapShot.length; i++) {
      print(_dataSnapShot[i].userLocation);
      var x= _dataSnapShot[i].userLocation.split(",");
      String id = 'markerId$i';
      final MarkerId markerId = MarkerId(id);
      final Marker marker = Marker(
        markerId: markerId,
        icon: pinDefaultIcon1,

        position: LatLng(
          double.parse(x[0]),
          double.parse(x[1]),
        ),
        //infoWindow: InfoWindow(title: _dataSnapShot[i].productName),
        onTap: () {
          setState(() {
           _pageController = PageController(initialPage: i);
            _highlightMaker(MarkerId("markerId$i"));
            _markerId = i;
             pinLocationIcon0 = pinDefaultIcon1;
          });
        },
      );
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  Widget _pageViewBuilder(BuildContext context) {
    return FutureBuilder<List<User>>(
        future:  Provider.of<HomeProvider>(context, listen: true)
            .getAdsList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            case ConnectionState.active:
              return Text('');
            case ConnectionState.waiting:
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Error(
                  errorMessage: snapshot.error.toString(),
                  onRetryPressed: () {},
                );
              } else {
                if (snapshot.data.length > 0) {
                  return PageView.builder(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        var animation = Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval((1 / count) * itemIndex, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        _animationController.forward();
                        return Container(

                          margin: EdgeInsets.all(1),
                          child: InkWell(
                              onTap: () {
                                _homeProvider.setCurrentAds(snapshot
                                    .data[itemIndex].userId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdDetailsScreen(
                                              user: snapshot
                                                  .data[itemIndex],
                                            )));
                              },
                              child: ProductItem(
                                animationController:
                                _animationController,
                                animation: animation,
                                user: snapshot.data[itemIndex],
                              )),
                        );

                      });
                } else {
                  return Text("No date");
                }
              }
          }
          return Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height * 0.2;
    _width = MediaQuery.of(context).size.width;



    return Scaffold(
      body: Stack(children: <Widget>[

        Container(
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            initialCameraPosition: CameraPosition(target: _center),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(MapStyle.style);
              googleMapController = controller;
              _controller.complete(controller);
              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(double.parse(_homeProvider.latValue), double.parse(_homeProvider.longValue)),
                      zoom: 15.0)));
            },
            markers: Set<Marker>.of(markers.values),
          ),
        ),

        GestureDetector(
          onTap: (){
            _hideListView();
            _infoWindow = false;
          },
          child: (_infoWindow == true)
              ?Container(
            color: Colors.transparent,
          )
              : Container(),

        ),


        Positioned(
          bottom: 0,
          left: 10,
          right: 10,

          child: (_infoWindow == true)
              ?Container(

                  height: 200,
                  width: 380,
                  child: _pageViewBuilder(context),
                )
              : Container(),
        ),

      //  ,
      ]),
    );
  }
}

class MapStyle {
  static String style = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
''';
}
