
import 'package:flutter/material.dart';
import 'package:warshat/locale/app_localizations.dart';




class FavouriteDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    
    return  LayoutBuilder(builder: (context,constraints){
 return AlertDialog(
   contentPadding: EdgeInsets.fromLTRB(24.0,0.0,24.0,0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        height: 150,
        child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                
                Container(
            margin: EdgeInsets.only(top:10),
                  child: Icon(Icons.favorite,color: Colors.red
                  ,size: 70,))
             ,Text(AppLocalizations.of(context).translate('added_to_favourite_successfully'),style: TextStyle(
               color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18
             ),),
         
            ],
          )
      
    ));
    });
  }
}
