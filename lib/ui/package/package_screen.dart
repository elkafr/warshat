import 'package:warshat/models/country.dart';
import 'package:warshat/ui/account/app_commission_screen.dart';
import 'package:warshat/ui/account/pay_commission_screen.dart';
import 'package:warshat/ui/cities/cities_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'package:warshat/utils/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/ad_item/ad_item.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warshat/models/ad.dart';
import 'package:warshat/models/city.dart';
import 'package:warshat/models/package.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/ui/auth/loginc_screen.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';

import 'package:warshat/providers/auth_provider.dart';

class PackageScreen extends StatefulWidget {


  PackageScreen();
  @override
  State<StatefulWidget> createState() {
    return new _PackageScreenState();
  }
}


class _PackageScreenState extends State<PackageScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;

  Future<List<Package>> _packageList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;



  _PackageScreenState();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();


  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);

      //_homeProvider.updateSelectedCategory(iddd1);
      _packageList = _homeProvider.getPackageList();
      _initialRun = false;


    }


  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        Container(
            height: _height,
            color: Color(0xffF8F8FA),
            padding: EdgeInsets.fromLTRB(5,15,10,0),
            child: FutureBuilder<List<Package>>(
                future: _packageList,
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
                              shrinkWrap: false,
                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.8),
                              ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Consumer<HomeProvider>(

                                    builder: (context, homeProvider, child) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.only(top: 10),

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                          border: Border.all(
                                            color: hintColor.withOpacity(0.4),
                                          ),
                                          color: Colors.white,


                                        ),

                                        width: _width,
                                        child: Column(
                                          children: <Widget>[

                                            Text(snapshot.data[index].packageName,style: TextStyle(color: Color(0xff2E2E2E),fontSize: 16,fontWeight: FontWeight.bold),),
                                            Text(snapshot.data[index].packagePrice,style: TextStyle(color: mainAppColor,fontSize: 33,fontWeight: FontWeight.bold),),
                                            Text("ريال / "+snapshot.data[index].packagePeriod),

                                            CustomButton(
                                              btnLbl: "اشترك فى الباقة",
                                              btnColor: Colors.white,
                                              btnStyle: TextStyle(
                                                  color: Colors.black
                                              ),
                                              onPressedFunction: (){
                                                _homeProvider.setCurrentPackageId(snapshot.data[index].packageId);
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil('/pay_commission_screen', (Route<dynamic> route) => false);




                                              },
                                            ),



                                          ],
                                        ),
                                      );

                                    });
                              });
                        } else {
                          return NoData(message: 'لاتوجد نتائج');
                        }
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                })),






      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: _authProvider.currentLang == 'ar' ? Text("الباقات والاشتراكات",style: TextStyle(fontSize: 18,color: Colors.black),) :Text("Packages and subscriptions",style: TextStyle(fontSize: 18,color: Colors.black),),
      leading:    GestureDetector(
        child: Icon(Icons.arrow_back,color: Colors.black,size: 35,),
        onTap: (){
          Navigator.pop(context);
        },
      ),

    );
    _height =  MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;


    return PageContainer(
      child: Scaffold(
        backgroundColor: hintColor,
        appBar: appBar,
        body: _buildBodyItem(),

      ),
    );
  }
}
