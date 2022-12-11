import 'package:flutter/material.dart';
import 'package:warshat/locale/app_localizations.dart';
import 'package:warshat/models/chat_msg_between_members.dart';
import 'package:warshat/providers/auth_provider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';
import 'package:validators/validators.dart';


import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class ChatMsgItem extends StatefulWidget {
  
  final ChatMsgBetweenMembers chatMessage;
  const ChatMsgItem({Key key, this.chatMessage}) : super(key: key);

  @override
  _ChatMsgItemState createState() => _ChatMsgItemState();
}

class _ChatMsgItemState extends State<ChatMsgItem> {
  AuthProvider _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return widget.chatMessage.senderUserId == _authProvider.currentUser.userId
          ? Container(
              width: constraints.maxWidth * 0.4,
              margin: EdgeInsets.only(
                  top: constraints.maxHeight * 0.15,
                  right: constraints.maxWidth * 0.03,
                  left: constraints.maxWidth * 0.3),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffBFBFBF),
                    blurRadius: 1.0,
                  ),
                ],
                border: Border.all(
                  width: 0.1,
                  color: Color(0xffBFBFBF),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                color: Colors.grey[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.02,
                            ),
                        child: Text(AppLocalizations.of(context).translate('you'),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: mainAppColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700
                            )),
                      ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.02,
                           ),
                        child: Html(data: widget.chatMessage.messageContent,
                          onLinkTap: (link) {
                            launch(link);
                          },
                        ),
                      ),
                  Row(
      children: <Widget>[
   Container(
     margin: EdgeInsets.only(
                                                 right: _authProvider.currentLang == 'ar' ? constraints.maxWidth * 0.02 :0,
                            left: _authProvider.currentLang != 'ar' ? constraints.maxWidth * 0.02 :0,
                           ),
     child: Image.asset('assets/images/time.png',color: Color(0xffC5C5C5),
     height: 20,
     width: 20,
     ),
   ),
 Container(
  margin: EdgeInsets.only(right: _authProvider.currentLang == 'ar' ? 5 :0,
  left: _authProvider.currentLang != 'ar' ? 5 : 0),
  child:   Text(widget.chatMessage.messageDate,style: TextStyle(
     fontSize: 12,color: Color(0xffC5C5C5)
   ),))
      ],
    )
              
                
                ],
              ))
          : Container(
              width: constraints.maxWidth * 0.4,
              margin: EdgeInsets.only(
                  top: constraints.maxHeight * 0.15,
                  left: constraints.maxWidth * 0.03,
                  right: constraints.maxWidth * 0.3),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: accentColor,
                    blurRadius: 1.0,
                  ),
                ],
                border: Border.all(
                  width: 0.1,
                  color: Color(0xffBFBFBF),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                color: Colors.grey[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.02,
                            ),
                        child: Text(widget.chatMessage.messageSender,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700
                            )),
                      ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.02,
                           ),
                        child: Html(data: widget.chatMessage.messageContent),
                      ),
                  Row(
      children: <Widget>[
   Container(
     margin: EdgeInsets.only(
                            right: _authProvider.currentLang == 'ar' ? constraints.maxWidth * 0.02 :0,
                            left: _authProvider.currentLang != 'ar' ? constraints.maxWidth * 0.02 :0,
                           ),
     child: Image.asset('assets/images/time.png',color: Color(0xffC5C5C5),
     height: 20,
     width: 20,
     ),
   ),
 Container(
  margin: EdgeInsets.only(right: _authProvider.currentLang == 'ar' ? 5 :0,
  left: _authProvider.currentLang != 'ar' ? 5 : 0),
  child:   Text(widget.chatMessage.messageDate,style: TextStyle(
     fontSize: 12,color: Color(0xffC5C5C5)
   ),))
      ],
    )
              
                
                ],
              ));
    });
  }
}
