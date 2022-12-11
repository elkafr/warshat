import 'dart:ffi';

import 'package:warshat/ui/auth/loginc_screen.dart';
import 'package:warshat/ui/comment/comment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:warshat/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/userDetails.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/ad_details_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/favourite_provider.dart';
import 'package:warshat/ui/chat/chat_screen.dart';
import 'package:warshat/ui/section_ads/section_ads_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warshat/ui/ad_details/widgets/slider_images.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/comments/comment_bottom_sheet.dart';
import 'package:warshat/ui/comment/comment_screen.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/models/ad_details.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:warshat/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'dart:async';
import 'dart:math' as math;

class AdDetailsScreen extends StatefulWidget {
  final User user;

  const AdDetailsScreen({Key key, this.user}) : super(key: key);
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen>
    with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  HomeProvider _homeProvider;
  AnimationController _animationController;
  double _distanceInMeters;

  bool _initialRun = true;
  List x;

  String xx1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);

      _initialRun = false;
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/pin.png',
    );
  }


  void getDistance() async {
    var c = widget.user.userLocation.split(",");
     _distanceInMeters = await Geolocator().distanceBetween(
      double.parse(c[0]),
      double.parse(c[1]),
      double.parse(_homeProvider.latValue),
      double.parse(_homeProvider.longValue),
    );
     
  }

  Widget _buildRow(
      {@required String imgPath,
      @required String title,
      @required String value}) {



    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          height: 15,
          width: 15,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Color(0xff5FB019), fontSize: 14),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildItem(String title, String imgPath) {
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(2)),
        Image.asset(
          imgPath,
          color: Color(0xffFF9408),
          height: 16,
          width: 16,
        ),
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Container(
              margin: EdgeInsets.only(
                  left: authProvider.currentLang == 'ar' ? 0 : 2,
                  right: authProvider.currentLang == 'ar' ? 2 : 0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: title.length > 1 ? 16 : 16,
                    color: Color(0xffC5C5C5)),
                overflow: TextOverflow.ellipsis,
              ));
        })
      ],
    );
  }

  Widget _buildBodyItem() {
    String str = widget.user.userCatName;
    return FutureBuilder<UserDetails>(
        future: Provider.of<AdDetailsProvider>(context, listen: false)
            .getAdDetails(widget.user.userId,_homeProvider.latValue,_homeProvider.longValue),
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
                );
              } else {
                var initalLocation = snapshot.data.userLocation.
                split(',');
                LatLng pinPosition = LatLng(double.parse(initalLocation[0]), double.parse(initalLocation[1]));

                // these are the minimum required values to set
                // the camera position
                CameraPosition initialLocation = CameraPosition(
                  zoom: 15,
                 bearing: 30,
                   target: pinPosition
                 );

                return ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            snapshot.data.photos.length == 1
                                ? Container(
                                    height: 255,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)), //this right here
                                                child: Container(
                                                  child: GestureZoomBox(
                                                    maxScale: 5.0,
                                                    doubleTapScale: 2.0,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Image.network(
                                                      snapshot.data.userPhoto,
                                                      fit: BoxFit.fill,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: ClipRRect(
                                        child: Image.network(
                                          snapshot.data.userPhoto,
                                          fit: BoxFit.fill,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ),
                                  )
                                : SliderImages(),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffF1F1F1),
                                    Colors.white,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14)),
                              ),
                              width: _width,
                              margin:
                                  EdgeInsets.only(left: 12, right: 12, top: 12),
                              padding: EdgeInsets.only(
                                  right: 12, left: 12, bottom: 12, top: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget.user.userName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: mainAppColor,
                                            fontWeight: FontWeight.bold),
                                      ),


                                      RatingBar.builder(
                                        initialRating:  double.parse(widget.user.userRate),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.all(0),
                                        itemSize: 25,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) async {


                                          if(_authProvider.currentUser==null){

                                            Commons.showToast(context,
                                                message: "يجب عليك تسجيل الدخول اولا");

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginCScreen()));

                                          }else{

                                          final results = await _apiProvider
                                              .post(
                                              "https://wersh1.com/api/adsRate" +
                                                  "?api_lang=${_authProvider
                                                      .currentLang}", body: {
                                            "rate_user": _authProvider
                                                .currentUser.userId,
                                            "rate_ads": widget.user.userId,
                                            "rate_value": rating.toString(),

                                          });


                                          if (results['response'] == "1") {
                                            Commons.showToast(context,
                                                message: results["message"]);
                                          } else {
                                            Commons.showError(
                                                context, results["message"]);
                                          }
                                        }




                                        },
                                      ),


                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(7)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[

                                      GestureDetector(
                                        onTap: (){
                                          launch(
                                              "tel://${widget.user.userPhone}");
                                        },
                                        child:  Container(
                                          width: _width * .40,
                                          decoration: BoxDecoration(
                                            color: Color(0xffEBEBEB),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                  "assets/images/fullcall.png"),
                                              Padding(padding: EdgeInsets.all(7)),
                                              Text(widget.user.userPhone,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                      ),


                                      GestureDetector(
                                        onTap: (){
                                          launch(
                                              "https://wa.me/${widget.user.userWhats}");
                                        },
                                        child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: _width * .40,
                                              decoration: BoxDecoration(
                                                color: Color(0xffEBEBEB),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                      "assets/images/whats.png"),
                                                  Padding(padding: EdgeInsets.all(7)),
                                                  Text(widget.user.userWhats,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            )),
                                      )

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            bottom: 110,
                            right: 25,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60.0)),
                                border: Border.all(
                                  color: hintColor.withOpacity(.4),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: ClipOval(
                                  child: Image.network(
                                    widget.user.userPhoto,
                                    height: 109,
                                    width: 109,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                      ],
                      overflow: Overflow.visible,
                    ),



                    Wrap(
                      children: [
                        for (var s in str.split(','))
                          Container(
                            alignment: Alignment.center,

                            width:_width*.30,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: mainAppColor)),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 5, right: 5,bottom:5),
                            child: Text(s,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          )
                      ],
                    ),
                    Stack(

                      children: <Widget>[


                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(top: 45,right: 10,left: 10),
                          width: _width,

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.user.userAbout,
                            style: TextStyle(
                                color: Color(0xff797979), fontSize: 15),
                          ),
                        ),


                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(

                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(5),

                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(29.0),topRight: Radius.circular(10.0)),


                                color:mainAppColor,
                              ),
                              child: Text(_authProvider.currentLang=="ar"?"نبذة عن الورشة":"About the workshop",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )),
                        

                      ],
                    ),
                    SizedBox(height: 10,),

                    Container(
                        margin: EdgeInsets.only(top: 5,bottom: 35,right: 15,left: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10), topRight: Radius.circular(10),bottomRight:  Radius.circular(10)
                                ,bottomLeft:  Radius.circular(10)),
                            border: Border.all(
                              color: Color(0xffABABAB),
                              width: 1,
                            )
                        ),
                        child:   GestureDetector(
                            onTap: (){

                              if(_authProvider.currentUser==null){

                                Commons.showToast(context,
                                    message: "يجب عليك تسجيل الدخول اولا");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginCScreen()));

                              }else{

                                _homeProvider.setCurrentAds(widget.user.userId);
                                Navigator.push(context, MaterialPageRoute
                                  (builder: (context)=> CommentScreen()
                                ));



                              }

                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    _homeProvider.currentLang=="ar"?"شاهد التعليقات":"Show comments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, color: Color(0xffABABAB)),
                                  ),),


                              ],
                            ))),
                    

                    Container(
                      alignment: Alignment.center,
                      child: Text(_authProvider.currentLang=="ar"?"عنوان الورشة علي الخريطه":"Workshop Adress",style: TextStyle(
                          color: Colors.black, fontSize: 18,fontFamily: "Cairo")),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.pin_drop,size: 25,color: mainAppColor,),
                          Padding(padding: EdgeInsets.all(4)),
                          Text(widget.user.userAdress,style: TextStyle(
                              color: Color(0xffB2B2B2), fontSize: 16,fontFamily: "Cairo"))
                        ],
                      ),
                    ),


                    Stack(
                      children: <Widget>[



                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15
                          ),
                          height: 150,
                          decoration: BoxDecoration(
                            color:  Color(0xffF3F3F3),
                            border: Border.all(
                              width: 1.0,
                              color: Color(0xffF3F3F3),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child:   ClipRRect(
                              borderRadius: BorderRadius.all( Radius.circular(10.0)),
                              child: GoogleMap(

                                  myLocationEnabled: true,

                                  compassEnabled: true,

                                  markers: _markers,

                                  initialCameraPosition: initialLocation,

                                  onMapCreated: (GoogleMapController controller) {

                                    controller.setMapStyle(Commons.mapStyles);

                                    _controller.complete(controller);



                                    setState(() {

                                      _markers.add(

                                          Marker(

                                              markerId: MarkerId(snapshot.data.userId),

                                              position: pinPosition,

                                              icon: pinLocationIcon

                                          )

                                      );





                                    });



                                  })),
                        ),



                        Positioned(
                            bottom: -10,
                            child:  Container(

                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: _width*.25,left: _width*.20),
                              width: _width*.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: hintColor.withOpacity(0.4),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child: Text(snapshot.data.userDistance.toString()+" كم من موقعك الحالي ",style: TextStyle(color: Colors.black,fontSize: 16),),
                            )),

                      ],
                    ),


                      SizedBox(height: 20,)


                    /*  Container(
          height:_height*.45,

          decoration: BoxDecoration(

            border: Border.all(
              color: hintColor.withOpacity(0.4),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[

              SizedBox(height: 10),
              Container(
                alignment: _authProvider.currentLang == 'ar' ?Alignment.topRight:Alignment.topLeft,
                margin: EdgeInsets.symmetric(
                  horizontal: _width * 0.04,
                ),
                child: Text(
                  AppLocalizations.of(context).translate('comments'),
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: SingleChildScrollView(
                child:  Container(
                  padding: EdgeInsets.all(10),
                  width: _width,
                  child: (comments.length>0)?Column(
                    children:List.generate(comments.length,(index){
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Image.network(comments[index]['comment_user_image'],width: 50,height: 50,),
                          Padding(padding: EdgeInsets.all(5)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(comments[index]['comment_user_name'].toString(),style: TextStyle(fontSize: 16,color: mainAppColor)),
                              Padding(padding: EdgeInsets.all(5)),
                              Container(
                                width: 300,
                                child: Text(comments[index]['comment_details'].toString(),style: TextStyle(fontSize: 16,color: mainAppColor,),maxLines: 2,),
                              )
                            ],
                          )


                        ],
                      );
                    })
                  ):    NoData(message:  AppLocalizations.of(context).translate('no_results')),
                ),
              )),




              Container(
                  margin: EdgeInsets.only(top: 15,bottom: 35,right: 15,left: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), topRight: Radius.circular(10),bottomRight:  Radius.circular(10)
                        ,bottomLeft:  Radius.circular(10)),
                      border: Border.all(
                        color: Color(0xffABABAB),
                        width: 1,
                      )
                  ),
                  child:   GestureDetector(
                      onTap: (){

                    if(_authProvider.currentUser==null){

                    Commons.showToast(context,
                    message: "يجب عليك تسجيل الدخول اولا");

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen()));

                    }else{


                        showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (builder) {
                              return Container(
                                  width: _width,
                                  height: _height * 0.6,
                                  child: CommentBottomSheet());
                            });

                    }

                      },
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                AppLocalizations.of(context).translate('addcomment'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Color(0xffABABAB)),
                              ),),


                        ],
                      )))


            ],
          ),
        ), */

/*
Container(
  margin: EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 15
  ),
  height: 150,
   decoration: BoxDecoration(
              color:  Color(0xffF3F3F3),
              border: Border.all(
                width: 1.0,
                color: Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
  child:   ClipRRect(
    borderRadius: BorderRadius.all( Radius.circular(10.0)),
    child: GoogleMap(

        myLocationEnabled: true,

        compassEnabled: true,

        markers: _markers,

        initialCameraPosition: initialLocation,

        onMapCreated: (GoogleMapController controller) {

            controller.setMapStyle(Commons.mapStyles);

            _controller.complete(controller);



     setState(() {

              _markers.add(

                  Marker(

                    markerId: MarkerId(snapshot.data.adsId),

                    position: pinPosition,

                    icon: pinLocationIcon

                  )

              );





  });



        })),
),

*/
                  ],
                );
              }
          }
          return Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      backgroundColor: mainAppColor,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 35,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        widget.user.userName,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      actions: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 6, left: 6),
            child: _authProvider.currentUser == null
                ? GestureDetector(
                    onTap: () {
                      _homeProvider.setLoginValue("0");
                      Navigator.pushNamed(context, '/loginc_screen');
                    },
                    child: SpinKitPumpingHeart(
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : Consumer<FavouriteProvider>(
                    builder: (context, favouriteProvider, child) {
                    return GestureDetector(
                      onTap: () async {
                        if (favouriteProvider.favouriteAdsList
                            .containsKey(widget.user.userId)) {
                          favouriteProvider
                              .removeFromFavouriteAdsList(widget.user.userId);
                          await _apiProvider.get(Urls.REMOVE_AD_from_FAV_URL +
                              "ads_id=${widget.user.userId}&user_id=${_authProvider.currentUser.userId}");
                        } else {
                          favouriteProvider.addToFavouriteAdsList(
                              widget.user.userId, 1);
                          await _apiProvider.post(Urls.ADD_AD_TO_FAV_URL,
                              body: {
                                "user_id": _authProvider.currentUser.userId,
                                "ads_id": widget.user.userId
                              });
                        }
                      },
                      child: Center(
                        child: favouriteProvider.favouriteAdsList
                                .containsKey(widget.user.userId)
                            ? SpinKitPumpingHeart(
                                color: Colors.red,
                                size: 30,
                              )
                            : SpinKitPumpingHeart(
                                color: Colors.white,
                                size: 30,
                              ),
                      ),
                    );
                  })),
      ],
    );

    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),
            ],
          )),
    );
  }
}
