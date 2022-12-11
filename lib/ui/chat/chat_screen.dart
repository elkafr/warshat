import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:warshat/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:warshat/custom_widgets/no_data/no_data.dart';
import 'package:warshat/custom_widgets/safe_area/page_container.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/chat_message.dart';
import 'package:warshat/models/chat_msg_between_members.dart';
import 'package:warshat/networking/api_provider.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/providers/chat_provider.dart';
import 'package:warshat/ui/chat/widgets/chat_msg_item.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/utils/commons.dart';
import 'package:warshat/utils/error.dart';
import 'package:warshat/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:warshat/ui/home/home_screen.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receverId;
  final String senderName;
  final String senderImg;
  final String senderPhone;
  final String adsId;

  const ChatScreen(
      {Key key,
      this.senderId,
      this.receverId,
      this.senderName,
      this.senderImg,
      this.senderPhone,
        this.adsId,
      })
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double _height = 0, _width = 0;
  AuthProvider _authProvider;
  ApiProvider _apiProvider = ApiProvider();
  TextEditingController _messageController = TextEditingController();
  LocationData _locData;

  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
      AppLocalizations.of(context).translate('detect_location'));
      setState(() {

        _messageController.text="<a href='"+"https://www.google.com/maps/search/?api=1&query="+_locData.latitude.toString()+","+_locData.longitude.toString()+"'>اللوكيشن</a>";
      });
    }
  }

  Widget _buildBodyItem() {
    return Column(
      children: <Widget>[


        (_authProvider.currentUser.userId==widget.receverId)?Container(
          height: _height * 0.1,
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
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
    _getCurrentUserLocation();

    },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/city.png"),
                      Padding(padding: EdgeInsets.all(2)),
                      Text("ارسال موقع التسليم")
                    ],
                  ),
                ),
              ),


              Spacer(),
              GestureDetector(
                onTap: () async{

                  setState(() {
                    _messageController.text=widget.senderPhone;
                  });
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                    child: Row(
                      children: <Widget>[
                        Image.asset("assets/images/fullcall.png"),
                        Padding(padding: EdgeInsets.all(2)),
                        Text("ارسال رقم التواصل")
                      ],
                    )),
              )
            ],
          ),
        ):Text(""),


        Expanded(
          child: FutureBuilder<List<ChatMsgBetweenMembers>>(
              future: Provider.of<ChatProvider>(context, listen: false)
                  .getChatMessageList(widget.senderId,widget.adsId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return SpinKitFadingCircle(color: mainAppColor);
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.waiting:
                    return SpinKitFadingCircle(color: mainAppColor);
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Error(
                          //  errorMessage: snapshot.error.toString(),
                          errorMessage:
                              AppLocalizations.of(context).translate('error'),
                          onRetryPressed: () {
                            //  setState(() {
                            //    _refreshHandle();
                            //  });
                          });
                    } else {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: _width,
                                height: _height * 0.15,
                                child: ChatMsgItem(
                                  chatMessage: snapshot.data[index],
                                ),
                              );
                            });
                      } else {
                        return NoData(
                          message:
                              AppLocalizations.of(context).translate('no_msgs'),
                        );
                      }
                    }
                }
                return SpinKitFadingCircle(color: mainAppColor);
              }),
        ),
        Divider(),
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: _width * 0.03),
          width: _width,
          child: CustomTextFormField(
            enableHorizontalMargin: false,
            controller: _messageController,
            hintTxt: AppLocalizations.of(context).translate('enter_msg'),
            suffix: IconButton(
              icon: Icon(Icons.send,color: accentColor,),
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  final results = await _apiProvider.post(Urls.SEND_URL, body: {
                    "message_sender": _authProvider.currentUser.userId,
                    "message_recever": widget.senderId,
                    "message_content": _messageController.text,
                    "message_ads": widget.adsId,
                  });

                  if (results['response'] == "1") {
                    setState(() {
                      _messageController.clear();
                    });
                  } else {
                    Commons.showError(context, results["message"]);
                  }
                } else {
                  Commons.showToast(context,
                      message: AppLocalizations.of(context)
                          .translate('please_enter_msg'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      title: Text(AppLocalizations.of(context).translate('chat'),
          style: Theme.of(context).textTheme.headline1),
      centerTitle: true,
      backgroundColor: mainAppColor,
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
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);

    return PageContainer(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Scaffold(
          appBar: appBar,
          body: _buildBodyItem(),
        ),
      ),
    );
  }
}
