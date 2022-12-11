import 'package:flutter/material.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/utils/app_colors.dart';


class CategoryItem extends StatelessWidget {
  final CategoryModel category;
    final AnimationController animationController;
  final Animation animation;


  const CategoryItem({Key key, this.category, this.animationController, this.animation}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context, constraints) {
      return  Column(
        children: <Widget>[
          ListTile(

            title: Text(category.catName,style: TextStyle(
                color: Colors.black,fontSize: category.catName.length > 1 ?18 : 18
            ),

              overflow: TextOverflow.clip,
              maxLines: 1,),
          ),
          Container(
            height: 2,
            color: Color(0xffFBFBFB),
          )
        ],
      );

    });
  }
}
