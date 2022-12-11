import 'package:warshat/models/ad.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/utils/commons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warshat/providers/home_provider.dart';

class MapWidget extends StatefulWidget {
  final List<Ad> adList;

  const MapWidget({Key key, this.adList}) : super(key: key);
   @override
   State<StatefulWidget> createState() => MapWidgetState();
}
class MapWidgetState extends State<MapWidget> {

  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinLocationIcon1;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  HomeProvider _homeProvider;
  String xx;

  @override
  void initState() {
      super.initState();
      setCustomMapPin();
      setCustomMapPin1();
  }




  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/pin.png');
  }


  void setCustomMapPin1() async {
    pinLocationIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/active_marker.png');
  }

  @override
  Widget build(BuildContext context) {

    _homeProvider = Provider.of<HomeProvider>(context);


    var initalLocation = widget.adList[0].adsLocation.
     split(',');
    LatLng pinPosition = LatLng(double.parse(initalLocation[0]), double.parse(initalLocation[1]));

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 10,
        bearing: 30,
        target: pinPosition
    );

    return GoogleMap(

      myLocationEnabled: true,
      compassEnabled: true,
      markers: _markers,
      initialCameraPosition: initialLocation,
      onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(Commons.mapStyles);
          _controller.complete(controller);
          widget.adList.forEach((item) {

   var loc = item.adsLocation.split(',');


 pinPosition = LatLng(double.parse(loc[0]), double.parse(loc[1]));
   setState(() {
            _markers.add(
                Marker(
                  markerId: MarkerId(item.adsId),
                  position: pinPosition,
                  icon: pinLocationIcon,
                     onTap: () {
                    xx=item.adsId;
                    print(xx);
                                            print(item.adsTitle);
                                            },
                )
            );
          });

});

      });
  }


}
