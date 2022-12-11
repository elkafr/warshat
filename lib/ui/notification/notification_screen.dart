import 'package:warshat/ui/comment/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/notification_message.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/ui/chat/chat_screen.dart';
import 'package:warshat/providers/notification_provider.dart';
import 'package:warshat/providers/home_provider.dart';
import 'package:warshat/ui/notification/widgets/notification_item.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/ui/ad_details/ad_details_screen.dart';
import 'package:warshat/ui/home/home_screen.dart';
import 'dart:math' as math;
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/utils/urls.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/custom_widgets/dialogs/log_out_dialog.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  AnimationController _animationController;

  ApiProvider _apiProvider = ApiProvider();

  AuthProvider _authProvider;
  HomeProvider _homeProvider;

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
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Container(
            height: _height - 150,
            width: _width,
            child: FutureBuilder<List<NotificationMsg>>(
                future:
                    Provider.of<NotificationProvider>(context, listen: false)
                        .getMessageList(),
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
                            errorMessage: AppLocalizations.of(context)
                                .translate('error'));
                      } else {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var count = snapshot.data.length;
                                var animation =
                                    Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
                                _animationController.forward();
                                return Dismissible(
                                    // Each Dismissible must contain a Key. Keys allow Flutter to
                                    // uniquely identify widgets.
                                    key: Key(snapshot.data[index].messageId),
                                    // Provide a function that tells the app
                                    // what to do after an item has been swiped away.

                                    onDismissed: (direction) async {

                                      // Remove the item from the data source.
                                      await _apiProvider.get(Urls
                                              .DELETE_NOTIFICATION_URL +
                                          'user_id=${_authProvider.currentUser.userId}&notify_id=${snapshot.data[index].messageId}');
                                      setState(() {
                                        snapshot.data.removeAt(index);
                                      });
                                    },
                                    // Show a red background as the item is swiped away.
                                    direction: DismissDirection.startToEnd,

                                    background: Container(
                                      color: Colors.red,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(padding: EdgeInsets.all(10)),
                                          Image.asset(
                                            "assets/images/deleteall.png",color: Colors.white,alignment: Alignment.centerRight,
                                          ),
                                          Padding(padding: EdgeInsets.all(3)),
                                          Text("حذف",style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                    child: Container(
                                      color: snapshot.data[index].messageIsViewed=="0"?Color(0xffe5e5e5):Colors.white,
                                        height: _height * 0.100,
                                        child: GestureDetector(
                                            onTap: () async{



                                              final results = await _apiProvider
                                                  .post("https://wersh1.com/api/change_view" + "?api_lang=${_authProvider.currentLang}", body: {
                                                "message_id":snapshot
                                                    .data[index].messageId

                                              });


                                              if (results['response'] == "1") {
                                                //Commons.showToast(context, message: results["message"] );

                                              } else {
                                                Commons.showError(context, results["message"]);

                                              }



                                              print(snapshot
                                                  .data[index].messageView);
                                              _homeProvider.setCurrentAds(
                                                  snapshot.data[index]
                                                      .messageAdsId);

                                              snapshot.data[index]
                                                          .messageType ==
                                                      "message"
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                                senderId:snapshot
                                                                    .data[index]
                                                                    .messageSenderId,
                                                                senderImg: snapshot
                                                                    .data[index]
                                                                    .messageSenderPhoto,
                                                                senderName:
                                                                snapshot
                                                                    .data[index]
                                                                    .messageSenderName,
                                                                senderPhone:
                                                                snapshot
                                                                    .data[index]
                                                                    .messageSenderPhone,
                                                                adsId: snapshot
                                                                    .data[index]
                                                                    .messageAdsId,
                                                              )))
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentScreen()));
                                            },
                                            child: NotificationItem(
                                              enableDivider:
                                                  snapshot.data.length - 1 !=
                                                      index,
                                              animation: animation,
                                              animationController:
                                                  _animationController,
                                              notificationMsg:
                                                  snapshot.data[index],
                                            ))));
                              });
                        } else {
                          return NoData(
                              message: AppLocalizations.of(context)
                                  .translate('no_results'));
                        }
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

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
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(5)),
                      GestureDetector(
                        child: Image.asset('assets/images/deleteall.png',
                            color: accentColor),
                        onTap: () async {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) {
                                return LogoutDialog(
                                  alertMessage: AppLocalizations.of(context)
                                      .translate('are_you_shure'),
                                  onPressedConfirm: () async {
                                    final results = await _apiProvider.post(
                                        Urls.DELETE_NOTIFICATION_URL_ALL,
                                        body: {
                                          "user_id":
                                              _authProvider.currentUser.userId,
                                        });

                                    if (results['response'] == "1") {
                                      Commons.showToast(context,
                                          message: results["message"]);
                                      Navigator.pop(context);
                                      setState(() {});
                                    } else {
                                      Commons.showError(
                                          context, results["message"]);
                                    }
                                  },
                                );
                              });
                        },
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).translate('deleteall'),
                          style: TextStyle(color: accentColor, fontSize: 16),
                        ),
                        onTap: () async {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) {
                                return LogoutDialog(
                                  alertMessage: AppLocalizations.of(context)
                                      .translate('are_you_shure'),
                                  onPressedConfirm: () async {
                                    final results = await _apiProvider.post(
                                        Urls.DELETE_NOTIFICATION_URL_ALL,
                                        body: {
                                          "user_id":
                                              _authProvider.currentUser.userId,
                                        });

                                    if (results['response'] == "1") {
                                      Commons.showToast(context,
                                          message: results["message"]);
                                      Navigator.pop(context);
                                      setState(() {});
                                    } else {
                                      Commons.showError(
                                          context, results["message"]);
                                    }
                                  },
                                );
                              });
                        },
                      )
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context).translate('notifications'),
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 35,
                        ),
                        onTap: () {
                          Navigator.pop(context);
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
