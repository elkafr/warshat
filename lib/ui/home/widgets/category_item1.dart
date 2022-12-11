import 'package:flutter/material.dart';
import 'package:warshat/models/category.dart';
import 'package:warshat/ui/home/cats_screen.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:warshat/providers/home_provider.dart';


class CategoryItem1 extends StatelessWidget {
  final CategoryModel category;
  final AnimationController animationController;
  final Animation animation;


  const CategoryItem1({Key key, this.category, this.animationController, this.animation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(

        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: constraints.maxHeight *0.05),
              width: constraints.maxWidth *0.8,
              height: constraints.maxHeight *0.5,
              decoration: BoxDecoration(
                color: category.isSelected ?  Colors.white : Color(0xffF3F3F3),
                border: Border.all(
                  width: 1.0,
                  color: category.isSelected ? accentColor: Color(0xffF3F3F3),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all( Radius.circular(10.0)),
                  child: Image.network(category.catImage,fit: BoxFit.none,cacheWidth: 45,cacheHeight: 45,))
            ),

          ),
          Container(
            alignment: Alignment.center,
            width: constraints.maxWidth,
            child: Text(category.catName,style: TextStyle(
                color: Colors.black,fontSize: category.catName.length > 1 ?13 : 13
            ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,),
          ),

        ],
      );
    });
  }
}
