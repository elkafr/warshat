import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/buttons/custom_button.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/ui/edit_ad/edit_ad_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';

class MyAdItem extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final User user;

  const MyAdItem({Key key, this.animationController, this.animation, this.user})
      : super(key: key);
  @override
  _MyAdItemState createState() => _MyAdItemState();
}

class _MyAdItemState extends State<MyAdItem> {
  double _height = 0 ,_width = 0;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);


    Widget _buildItem(String title,String imgPath){
      return Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(2)),
          Image.asset(imgPath,color: Color(0xffFF9408),
            height: 16,
            width: 16,
          ),
          Consumer<AuthProvider>(
              builder: (context,authProvider,child){
                return  Container(
                    margin: EdgeInsets.only(left: authProvider.currentLang == 'ar' ? 0 : 2,right:  authProvider.currentLang == 'ar' ? 2 : 0 ),
                    child:   Text(title,style: TextStyle(
                        fontSize: title.length >1 ?14 : 14,color: Color(0xffC5C5C5)
                    ),
                      overflow: TextOverflow.ellipsis,
                    ));
              }
          )
        ],
      );
    }


    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: widget.animation,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 50 * (1.0 - widget.animation.value), 0.0),
                  child:LayoutBuilder(builder: (context, constraints) {
                    _height =  constraints.maxHeight;
                    _width = constraints.maxWidth;
                    return Container(

                      margin: EdgeInsets.only(left: constraints.maxWidth *0.03,
                          right: constraints.maxWidth *0.02,bottom: constraints.maxHeight *0.1),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
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
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(_authProvider.currentLang == 'ar' ? 10 :0),
                                        bottomRight: Radius.circular(_authProvider.currentLang == 'ar' ? 10 :0),
                                        bottomLeft: Radius.circular((_authProvider.currentLang != 'ar' ? 10 :0),
                                        ),
                                        topLeft: Radius.circular((_authProvider.currentLang != 'ar' ? 10 :0))
                                    )
                                ),
                                child: ClipRRect(

                                    child: Image.network(widget.user.userPhoto ,height: constraints.maxHeight *0.4,
                                      width: constraints.maxWidth,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Expanded(
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(

                                      margin: EdgeInsets.symmetric(
                                          vertical: constraints.maxHeight *0.04,
                                          horizontal: constraints.maxWidth *0.02
                                      ),
                                      width: constraints.maxWidth *0.85,

                                      child:  Text(widget.user.userName,style: TextStyle(
                                        color: Colors.black,fontSize: 16,
                                        height: 1.0,

                                      ),
                                        maxLines: 2,
                                      ),
                                      height: 30,
                                    ),


                                    _buildItem(widget.user.userPhone, 'assets/images/time.png'),
                                    _buildItem(widget.user.userCityName, 'assets/images/pin.png'),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                     children: <Widget>[
                                       Container(

                                        padding: EdgeInsets.all(2),
                                           margin: EdgeInsets.only(right: 10),
                                           height: 32,
                                           decoration: BoxDecoration(
                                             color: accentColor,
                                             borderRadius: BorderRadius.only(
                                                 topLeft: Radius.circular(5), topRight: Radius.circular(5),bottomRight:  Radius.circular(5)
                                                 ,bottomLeft:  Radius.circular(5)),
                                           ),
                                           child:   GestureDetector(
                                               onTap: (){


                                               },
                                               child:Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: <Widget>[
                                                   Container(
                                                       margin: EdgeInsets.symmetric(horizontal: 2),
                                                       child: Image.asset('assets/images/edit.png',color: Colors.white,)),
                                                   Text(
                                                     AppLocalizations.of(context).translate('edit'),
                                                     style: TextStyle(
                                                       fontSize: 14,
                                                          color: Colors.white),
                                                   ),

                                                 ],
                                               ))),
                                              Spacer(),

                                       Container(
                                           padding: EdgeInsets.all(2),
                                           margin: EdgeInsets.only(left: 3),
                                           height: 32,
                                           decoration: BoxDecoration(
                                             color: mainAppColor,
                                             borderRadius: BorderRadius.only(
                                                 topLeft: Radius.circular(5), topRight: Radius.circular(5),bottomRight:  Radius.circular(5)
                                                 ,bottomLeft:  Radius.circular(5)),
                                           ),
                                           child:   GestureDetector(
                                               onTap: () async{

                                                 showDialog(
                                                     barrierDismissible: true,
                                                     context: context,
                                                     builder: (_) {
                                                       return LogoutDialog(
                                                         alertMessage:
                                                         AppLocalizations.of(context).translate('are_you_shure'),
                                                         onPressedConfirm: () async{


                                                           setState(() {
                                                             _isLoading = true;
                                                           });
                                                           final results =
                                                           await _apiProvider.post(
                                                               Urls.DELETE_AD_URL +
                                                                   "?id=${widget.user.userId}&user_id=${_authProvider.currentUser.userId}&api_lang=${_authProvider.currentLang}");

                                                           setState(() =>
                                                           _isLoading = false);
                                                           if (results['response'] ==
                                                               "1") {
                                                             Commons.showToast(context,
                                                                 message: results[
                                                                 "message"]);
                                                             Navigator
                                                                 .pushReplacementNamed(
                                                                 context,
                                                                 '/my_ads_screen');
                                                           } else {
                                                             Commons.showError(context,
                                                                 results["message"]);
                                                           }


                                                         },
                                                       );
                                                     });



                                               },
                                               child:Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: <Widget>[
                                                   Container(
                                                       margin: EdgeInsets.symmetric(horizontal: 5),
                                                       child: Image.asset('assets/images/delete.png',color: Colors.white,)),
                                                   Text(
                                                     AppLocalizations.of(context).translate('delete'),
                                                     style: TextStyle(
                                                         fontSize: 14,
                                                         color: Colors.white),
                                                   ),

                                                 ],
                                               )))
                                     ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          /* Positioned(
              top: constraints.maxHeight *0.02,

              child: Container(
                height: _height *0.25,
                width: _width *0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,

                ),
                child: _authProvider.currentUser == null
                        ? GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/login_screen'),
                            child: Center(
                                child: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.white,
                            )),
                          )
                        : Consumer<FavouriteProvider>(
                            builder: (context, favouriteProvider, child) {
                            return GestureDetector(
                              onTap: () async {
                                if (favouriteProvider.favouriteAdsList
                                    .containsKey(widget.ad.adsId)) {
                                  favouriteProvider.removeFromFavouriteAdsList(
                                      widget.ad.adsId);
                                  await _apiProvider.get(Urls
                                          .REMOVE_AD_from_FAV_URL +
                                      "ads_id=${widget.ad.adsId}&user_id=${_authProvider.currentUser.userId}");
                                  if (widget.insideFavScreen) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavouriteScreen()));
                                  }
                                } else {
                                  print(
                                      'user id ${_authProvider.currentUser.userId}');
                                  print('ad id ${widget.ad.adsId}');
                                  favouriteProvider.addToFavouriteAdsList(
                                      widget.ad.adsId, 1);
                                  await _apiProvider
                                      .post(Urls.ADD_AD_TO_FAV_URL, body: {
                                    "user_id": _authProvider.currentUser.userId,
                                    "ads_id": widget.ad.adsId
                                  });
                                }
                              },
                              child: Center(
                                child: favouriteProvider.favouriteAdsList
                                        .containsKey(widget.ad.adsId)
                                    ? SpinKitPumpingHeart(
                                        color: accentColor,
                                        size: 18,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          })

              ) ,
            )*/




                        ],
                      ),
                    );
                  })));
        });
  }
}
