import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';

import 'package:warshat/models/ad.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/providers/home_provider.dart';

import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/home/widgets/category_item.dart';
import 'package:warshat/ui/home/widgets/map_widget.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';

import 'package:warshat/providers/auth_provider.dart';

class CitScreen extends StatefulWidget {
  final String iddd;
  final int iddd1;
  CitScreen({this.iddd,this.iddd1});
  @override
  State<StatefulWidget> createState() {
    return new _CitScreenState(iddd: this.iddd,iddd1: this.iddd1);
  }
}


class _CitScreenState extends State<CitScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;

  Future<List<City>> _cityList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;


  final String iddd;
  final int iddd1;
  _CitScreenState({this.iddd,this.iddd1});


  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
    print(iddd1);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);

      //_homeProvider.updateSelectedCategory(iddd1);
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:iddd);
      _initialRun = false;


    }


  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {

    final orientation = MediaQuery.of(context).orientation;
    return ListView(
      children: <Widget>[



        Container(
            padding: EdgeInsets.all(15),
            height: _height*.9,
            width: _width,
            child:
            Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return FutureBuilder<List<Ad>>(
                  future:  Provider.of<HomeProvider>(context, listen: true)
                      .getAdsListByCity(iddd),
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
                                  ,childAspectRatio: _width / (_height / 1.18)),
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
                                          _homeProvider.setCurrentAds(snapshot
                                              .data[index].adsId);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdDetailsScreen(
                                                        ad: snapshot
                                                            .data[index],
                                                      )));
                                        },
                                        child: AdItem(
                                          animationController:
                                          _animationController,
                                          animation: animation,
                                          ad: snapshot.data[index],
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
    );
  }

  @override
  Widget build(BuildContext context) {

    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
      title:Text(_homeProvider.currentCityName,style: TextStyle(fontSize: 20)),


    );
    _height =  MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return PageContainer(
      child: Scaffold(
        appBar: appBar,
        body: _buildBodyItem(),
      ),
    );
  }
}
