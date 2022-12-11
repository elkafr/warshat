import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:warshat/providers/location_state.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/utils/app_colors.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class LocationDialog extends StatefulWidget {
 
  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
    Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = Set();
    LocationState _locationState;
    HomeProvider _homeProvider;
     Marker _marker;

  @override
  Widget build(BuildContext context) {
  _locationState = Provider.of<LocationState>(context);
  _homeProvider = Provider.of<HomeProvider>(context);


  _marker = Marker(

         // optimized: false,
    zIndex: 5,
        onTap: () {
            print('Tapped');
          },
          draggable: true,
         onDragEnd: ((value) async {
           print('ismail');
            print(value.latitude);
            print(value.longitude);
            _locationState.setLocationLatitude(double.parse(_homeProvider.latValue));
            _locationState.setLocationlongitude(double.parse(_homeProvider.longValue));
  //              final coordinates = new Coordinates(
  //                _locationState.locationLatitude, _locationState
  //  .locationlongitude);
   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                 _locationState.locationLatitude, _locationState
   .locationlongitude);
  _locationState.setCurrentAddress(placemark[0].name);

      //   var addresses = await Geocoder.local.findAddressesFromCoordinates(
      //     coordinates);
      //   var first = addresses.first;
      // _locationState.setCurrentAddress(first.addressLine);
      // print(_locationState.address);
          }),
        markerId: MarkerId('my marker'),
        // infoWindow: InfoWindow(title: widget.address),
         position: LatLng(double.parse(_homeProvider.latValue), 
         double.parse(_homeProvider.longValue)),
         flat: true
        );
   _markers.add( _marker);
      
    return  LayoutBuilder(builder: (context,constraints){
 return AlertDialog(
   contentPadding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: SingleChildScrollView(
        child:  Column(
        
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
      
             Container(
                decoration: BoxDecoration(
                     color: mainAppColor,
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(15.00),
                          topRight:  Radius.circular(15.00),
                        ),
                        border: Border.all(color: mainAppColor)),
               alignment: Alignment.center,
               width: MediaQuery.of(context).size.width,
               height: 40,
            
               child: Text("اختار الموقع",style: TextStyle(
                 color: Colors.black,fontSize: 16,
                 fontWeight: FontWeight.w700
               ),),
             ),
             Container(
               height: 240,
               child:  GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        // myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(_homeProvider.latValue),
                double.parse(_homeProvider.longValue)),
            zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
          onCameraMove: ((_position) => _updatePosition(_position)),
      ),
             ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: Text("",style: TextStyle(
                height: 1.5,
               color: Color(0xffB7B7B7),fontSize: 11,fontWeight: FontWeight.w400
             )),
            ),
              Container(
              margin: EdgeInsets.only( bottom: 20, right: 15, left: 15),
              child: CustomButton(
                  height: 35,
                  btnLbl: "تاكيد",
                  onPressedFunction: () async {
                    Navigator.pop(context);
                  }))
             
          ],
        )),
      
    );
    });
  }

  Future<void> _updatePosition(CameraPosition _position) async {
    print(
        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    // Marker marker = _markers.firstWhere(
    //     (p) => p.markerId == MarkerId('marker_2'),
    //     orElse: () => null);

     _markers.remove(_marker);
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,

         
    
      ),
    );
     print(_position.target.latitude);
            print(_position.target.longitude);
            _locationState.setLocationLatitude(_position.target.latitude);
            _locationState.setLocationlongitude(_position.target.longitude);
               List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                 _locationState.locationLatitude, _locationState
   .locationlongitude);
  _locationState.setCurrentAddress(placemark[0].name + '  ' + placemark[0].administrativeArea + ' '
   + placemark[0].country);
  //              final coordinates = new Coordinates(
  //                _locationState.locationLatitude, _locationState
  //  .locationlongitude);
  //       var addresses = await Geocoder.local.findAddressesFromCoordinates(
  //         coordinates);
  //       var first = addresses.first;
  //     _locationState.setCurrentAddress(first.addressLine);
      print(_locationState.address);
      if (!mounted) return;
    setState(() {});
  }
}
