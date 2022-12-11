import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/commission_app.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/commission_app_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:warshat/utils/error.dart';

class AppCommissionScreen extends StatefulWidget {
  @override
  _AppCommissionScreenState createState() => _AppCommissionScreenState();
}

class _AppCommissionScreenState extends State<AppCommissionScreen> {
double _height = 0 , _width = 0;

String _adValue;
bool _initialRun = true;
CommisssionAppProvider _commisssionAppProvider;
Future<CommissionApp> _commissionApp;

  @override
  void didChangeDependencies() {

    
    super.didChangeDependencies();
    if (_initialRun) {
     
      _commisssionAppProvider = Provider.of<CommisssionAppProvider>(context);
      _commissionApp = _commisssionAppProvider.getCommissionApp();
      _initialRun = false;
    }
  }

  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Container(
            width:  _width *0.55,
            child: Text(
              value,
               overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,fontSize: 12, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Container(
      height: _height,
      width: _width,
      child: FutureBuilder<CommissionApp>(
         future: _commissionApp,
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
                   errorMessage:AppLocalizations.of(context).translate('error'),
                 );
               } else {
            return    Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  SizedBox(
            height: 70,
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${AppLocalizations.of(context).translate('app_commission')} ${snapshot.data.commition} %' ,style: TextStyle(
              color: hintColor
            ),)),

           Consumer<AuthProvider>(
             builder: (context,authProvider,child){
               return  Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment:  authProvider.currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
              child: Text( AppLocalizations.of(context).translate('ad_value'),style: TextStyle(
                color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700
              ),),
            );
             }
           ),
              CustomTextFormField(
                 inputData: TextInputType.number,
                   suffix:Text( AppLocalizations.of(context).translate('sr')), 
                    onChangedFunc: (text){
                      _adValue =text;
                      var commissionValue = double.parse(_adValue) * (double.parse(snapshot.data.commition) /100);
                    _commisssionAppProvider.setCommissionValue(commissionValue.toString());
                    },
                   
                ),
              Consumer<AuthProvider>(
             builder: (context,authProvider,child){
               return   Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
               alignment:  authProvider.currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
              child: Text(AppLocalizations.of(context).translate('value_of_commission_due'),style: TextStyle(
                color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700
              ),),
            );}),
              Container(
                margin: EdgeInsets.only(
                  top: 10
                ),
                child: Consumer<CommisssionAppProvider>
                (
                  builder: (context,commisssionAppProvider,child){
                    return Text('${commisssionAppProvider.commissionValue} ${AppLocalizations.of(context).translate('sr')}');
                  }
                )
              ),
            Consumer<AuthProvider>(
              builder: (context,authProvider,child){
                return     Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              alignment:  authProvider.currentLang == 'ar' ? Alignment.topRight : Alignment.topLeft,
              child: Text( AppLocalizations.of(context).translate('bank_accounts'),style: TextStyle(
                color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700
              ),),
            );
              }
            ),
            Expanded(
              child:    ListView.builder(
                          itemCount: snapshot.data.banks.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(15.00),
                                  ),
                                  border: Border.all(color: hintColor)),
                              height: 160,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          color: accentColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: (Radius.circular(15.0)),
                                              topRight: (Radius.circular(15.0)))),
                                      height: 45,
                                      width: _width,
                                      child: Center(
                                        child: Text(
                                          snapshot.data.banks[index].bankTitle,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                      )),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: _buildRow(
                                        '${AppLocalizations.of(context).translate('account_owner')}   :   ',
                                        snapshot.data.banks[index].bankName),
                                  ),
                                  _buildRow(
                                      '${AppLocalizations.of(context).translate('account_number')} :   ',
                                      snapshot.data.banks[index].bankAcount),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: _buildRow(
                                        '${AppLocalizations.of(context).translate('iban_number')}  :   ',
                                        snapshot.data.banks[index].bankIban),
                                  )
                                ],
                              ),
                            );
                          }),
            )
              ],
            );
               }
           }
           return Center(
             child: SpinKitFadingCircle(color: mainAppColor),
           );
         }),
    ),
  );
}

@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;


    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: mainAppColor,
      leading: null,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate('app_commission'),style: TextStyle(fontSize: 18),),
      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.all(5)),

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