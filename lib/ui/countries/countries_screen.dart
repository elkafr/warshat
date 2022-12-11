import 'package:warshat/models/country.dart';
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
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/search/search_bottom_sheet.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';

import 'package:warshat/providers/auth_provider.dart';

class CountriesScreen extends StatefulWidget {


  CountriesScreen();
  @override
  State<StatefulWidget> createState() {
    return new _CountriesScreenState();
  }
}


class _CountriesScreenState extends State<CountriesScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;

  Future<List<Country>> _countryList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;



  _CountriesScreenState();

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
      _countryList = _homeProvider.getCountryList();
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
            height: _height*.79,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(5,15,10,0),
            child: FutureBuilder<List<Country>>(
                future: _countryList,
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
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Consumer<HomeProvider>(

                                    builder: (context, homeProvider, child) {
                                      return InkWell(
                                        onTap: (){



                                            //_homeProvider.updateSelectedCategory(snapshot.data[index]);
                                            _homeProvider.setCurrentIndexCountry(snapshot.data[index]);
                                            _homeProvider.setCurrentCountryId(snapshot.data[index].countryId);





                                        },
                                        child: Container(
                                          width: _width,
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(

                                                title: Text(snapshot.data[index].countryName,style: TextStyle(
                                                    color: Colors.black,fontSize: snapshot.data[index].countryName.length > 1 ?18 : 18
                                                ),
                                                  
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,),
                                                trailing: (_homeProvider.currentIndexCountry==snapshot.data[index])?Image.asset("assets/images/true.png"):Text(""),
                                              ),
                                              Container(
                                                height: 2,
                                                color: Color(0xffFBFBFB),
                                              )
                                            ],
                                          ),
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


        Container(
            width:  _width,
            child: CustomButton(
              btnColor: accentColor,
              borderColor: accentColor,
              onPressedFunction: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CitiesScreen())
                );

              },
              btnStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
              btnLbl:_authProvider.currentLang == 'ar' ?"تم":"Select",
            ))



      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
      title: _authProvider.currentLang == 'ar' ? Text("اختر الدولة",style: TextStyle(fontSize: 18),) :Text("Select City",style: TextStyle(fontSize: 18)),
      actions: <Widget>[
       GestureDetector(
         child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
         onTap: (){
           Navigator.pushReplacement(
               context,
               MaterialPageRoute(
                   builder: (context) =>
                       HomeScreen()));
         },
       ),
        Padding(padding: EdgeInsets.all(5)),

      ],

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
