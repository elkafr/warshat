import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/user.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/favourite_provider.dart';
import 'package:warshat/ui/favourite/favourite_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';

class AdItemFav extends StatefulWidget {

  final AnimationController animationController;
  final Animation animation;
  final bool insideFavScreen;
  final User user;

  const AdItemFav({Key key, this.insideFavScreen = false, this.user, this.animationController, this.animation}) : super(key: key);
  @override
  _AdItemFavState createState() => _AdItemFavState();
}

class _AdItemFavState extends State<AdItemFav> {
  double _height = 0 ,_width = 0;
  bool _initialRun = true;
  AuthProvider _authProvider;
  FavouriteProvider _favouriteProvider;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _favouriteProvider = Provider.of<FavouriteProvider>(context);

      if (widget.user.userIsFavorite == 1 && _authProvider.currentUser != null) {
        _favouriteProvider.addItemToFavouriteAdsList(
            widget.user.userId, widget.user.userIsFavorite);
      }

      _initialRun = false;
    }
  }

  Widget _buildItem(String title,String imgPath){
    return Row(
      children: <Widget>[
        Image.asset(imgPath,color: Color(0xffC5C5C5),
          height: _height *0.15,
          width: 20,
        ),
        Consumer<AuthProvider>(
            builder: (context,authProvider,child){
              return  Container(
                  margin: EdgeInsets.only(left: authProvider.currentLang == 'ar' ? 0 : 2,right:  authProvider.currentLang == 'ar' ? 2 : 0 ),
                  child:   Text(title,style: TextStyle(
                      fontSize: title.length >1 ?10 : 12,color: Color(0xffC5C5C5)
                  ),
                    overflow: TextOverflow.ellipsis,
                  ));
            }
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return   AnimatedBuilder(
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
                      margin: EdgeInsets.only(left: constraints.maxWidth *0.02,
                          right: constraints.maxWidth *0.02,bottom: constraints.maxHeight *0.1),
                     padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                          Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(11.0)),
                                    border: Border.all(
                                      color: Color(0xffE2E2E2),
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                      constraints.maxHeight * 0.04,
                                      horizontal:
                                      constraints.maxWidth * 0.02),
                                  child:  Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(11.0)),
                                        child: Image.network(
                                          widget.user.userPhoto,
                                          height: constraints.maxHeight*.90,
                                          width: constraints.maxWidth * 0.3,
                                          fit: BoxFit.cover,
                                        )),
                                    margin: EdgeInsets.all(9),
                                  )),
                              Expanded(
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.all(6)),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: constraints.maxHeight *0.04,
                                          horizontal: constraints.maxWidth *0.02
                                      ),
                                      width: constraints.maxWidth *0.62,

                                      child:  Text(
                                        widget.user.userName,
                                        style: TextStyle(
                                            color: mainAppColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            height: 1.4),
                                        maxLines: 2,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Container(
                                      width: constraints.maxWidth *0.58,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: constraints.maxWidth *0.02
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.map,size:22,color: Color(0xff5B7385)),
                                          Padding(padding: EdgeInsets.all(3)),
                                          Text(
                                            widget.user.userAdress,
                                            style: TextStyle(
                                                color: Color(0xff5B7385),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                height: 1.4),
                                            maxLines: 2,
                                          )
                                        ],
                                      ),
                                    ),






                                  ],
                                ),
                              )
                            ],
                          ),

                          Positioned(
                            top: constraints.maxHeight *0.02,
                            left: constraints.maxHeight *0.02,

                            child: Container(
                                height: _height *0.25,
                                width: _width *0.1,

                                child: _authProvider.currentUser == null
                                    ? GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/loginc_screen'),
                                  child: Center(
                                      child: Icon(
                                        Icons.star_border,
                                        size: 20,
                                        color: hintColor,
                                      )),
                                )
                                    : Consumer<FavouriteProvider>(
                                    builder: (context, favouriteProvider, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (favouriteProvider.favouriteAdsList
                                              .containsKey(widget.user.userId)) {
                                            favouriteProvider.removeFromFavouriteAdsList(
                                                widget.user.userId);
                                            await _apiProvider.get(Urls
                                                .REMOVE_AD_from_FAV_URL +
                                                "ads_id=${widget.user.userId}&user_id=${_authProvider.currentUser.userId}");
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
                                            print('ad id ${widget.user.userId}');
                                            favouriteProvider.addToFavouriteAdsList(
                                                widget.user.userId, 1);
                                            await _apiProvider
                                                .post(Urls.ADD_AD_TO_FAV_URL, body: {
                                              "user_id": _authProvider.currentUser.userId,
                                              "ads_id": widget.user.userId
                                            });
                                          }
                                        },
                                        child: Center(
                                          child: favouriteProvider.favouriteAdsList
                                              .containsKey(widget.user.userId)
                                              ? Icon(
                                            Icons.star,
                                            size: 30,
                                            color: mainAppColor,
                                          )
                                              : Icon(
                                            Icons.star,
                                            size: 30,
                                            color: hintColor,
                                          ),
                                        ),
                                      );
                                    })

                            ) ,
                          )
                        ],
                      ),
                    );
                  })));
        });
  }
}
