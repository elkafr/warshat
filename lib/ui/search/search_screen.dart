import 'package:warshat/custom_widgets/ad_item/ad_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/my_ads_provider.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/ui/my_ads/widgets/my_ad_item.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/utils/urls.dart';
import 'package:warshat/utils/commons.dart';

import 'dart:math' as math;
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  with TickerProviderStateMixin{
  double _height = 0 , _width = 0;
  NavigationProvider _navigationProvider;
  AnimationController _animationController;
  HomeProvider _homeProvider;

  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider ;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {

    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

    final orientation = MediaQuery.of(context).orientation;
    return ListView(
      children: <Widget>[
        Container(height: 20,),


        Container(
          color: Color(0xffFBFBFB),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                  padding: EdgeInsets.only(right: 20,top: 10),
                  child:    Text(
                    AppLocalizations.of(context).translate('neww'),
                    style: TextStyle(

                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  )
              ),

              Container(

                child: SingleChildScrollView(

                  child: Column(

                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(15,5,15,10),
                          height: _height,
                          width: _width,
                          child:
                          Consumer<HomeProvider>(builder: (context, homeProvider, child) {
                            return FutureBuilder<List<User>>(
                                future: Provider.of<HomeProvider>(context, listen: true)
                                    .getAdsSearchList(),
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
                                          //  errorMessage: snapshot.error.toString(),
                                          errorMessage: "حدث خطأ ما ",
                                        );
                                      } else {
                                        if (snapshot.data.length > 0) {

                                          return GridView.builder(
                                            itemCount: snapshot.data.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 2
                                                ,childAspectRatio: _width / (640 )),
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              var count = snapshot.data.length;
                                              var animation =
                                              Tween(begin: 0.0, end: 1.0).animate(
                                                CurvedAnimation(
                                                  parent: _animationController,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves.fastOutSlowIn),
                                                ),
                                              );
                                              _animationController.forward();
                                              return Container(
                                                  height: _height,
                                                  width: _width,
                                                  child: InkWell(
                                                      onTap: () {
                                                        //_homeProvider.setCurrentAds(snapshot
                                                            //.data[index].adsId);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AdDetailsScreen(
                                                                      user: snapshot
                                                                          .data[index],
                                                                    )));
                                                      },
                                                      child: AdItem(
                                                        animationController:
                                                        _animationController,
                                                        animation: animation,
                                                        user: snapshot.data[index],
                                                      )));
                                            },
                                          );

                                        } else {
                                          return NoData(message: 'لاتوجد نتائج');
                                        }
                                      }
                                  }
                                  return Center(
                                    child: SpinKitFadingCircle(color: mainAppColor),
                                  );
                                });
                          }))

                    ],
                  ),
                ),
              ),


            ],
          ),
        )



      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),
              Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: mainAppColor,

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[




                        ],
                      ),

                      Text( _authProvider.currentLang == 'ar' ? "نتيجة البحث":"Search result",
                        style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.start,),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                          Padding(padding: EdgeInsets.all(7))
                        ],
                      ),

                    ],
                  )),

            ],
          )),
    );
  }
}