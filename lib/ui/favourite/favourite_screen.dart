import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item_fav.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/providers/favourite_provider.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/providers/navigation_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:provider/provider.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/utils/urls.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';
import 'dart:math' as math;

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
  with TickerProviderStateMixin{
double _height = 0 , _width = 0;
  AnimationController _animationController;
HomeProvider _homeProvider;
NavigationProvider _navigationProvider;
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

Widget _buildBodyItem(){

  _height =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  _width = MediaQuery.of(context).size.width;

  final orientation = MediaQuery.of(context).orientation;


  return Column(
    children: <Widget>[
         SizedBox(
            height: 10,
          ),
              Container(
                padding: EdgeInsets.all(15),
          height: _height - 150,
          width: _width,
          child:FutureBuilder<List<User>>(
                  future:  Provider.of<FavouriteProvider>(context,
                          listen: true)
                      .getFavouriteAdsList(),
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

                        return ListView.builder(
                          itemCount: snapshot.data.length,

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
                                height: _height*.25,
                                width: _width,
                                child: InkWell(
                                    onTap: () {
                                     _homeProvider.setCurrentAds(snapshot
                                        .data[index].userId);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdDetailsScreen(
                                                    user: snapshot
                                                        .data[index],
                                                  )));
                                    },
                                    child: AdItemFav(
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
              })
        
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
  _homeProvider = Provider.of<HomeProvider>(context);


  final appBar = AppBar(
    elevation: 1,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    leading:    GestureDetector(
      child: Icon(Icons.arrow_back,color: Colors.black,size: 35,),
      onTap: (){
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    title: Text(AppLocalizations.of(context).translate('favourite'),style: TextStyle(fontSize: 18,color: Colors.black),),

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