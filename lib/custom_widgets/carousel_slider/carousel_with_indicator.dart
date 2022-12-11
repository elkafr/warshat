import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'package:flutter/material.dart';
import 'package:warshat/models/slider.dart';
import 'package:warshat/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';



List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  final List<SliderModel> imgList;

  const CarouselWithIndicator({ @required  this.imgList});
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        height: 139,
        autoPlay: true,
        viewportFraction: 1.0,
        aspectRatio: MediaQuery.of(context).size.aspectRatio * 4.5,
        items: map<Widget>(
          widget.imgList,
              (index, i) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(11.0)),
                  child:  Image.network(
                    i.photo,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              onTap: (){
                launch(i.url);
              },
            );
          },
        ).toList(),
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),

      Positioned(
        bottom: 5,
        left: MediaQuery.of(context).size.width * 0.45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            widget.imgList,
                (index, url) {
              // return   Container(
              //   alignment: Alignment.center,
              //                   margin: EdgeInsets.only(top: 5),
              //                   child: DotsIndicator(
              //                     dotsCount: widget.imgList.length,
              //                     position: _current.toDouble(),
              //                     decorator: DotsDecorator(
              //                       size: const Size(24.0, 5.0),
              //                       shape: RoundedRectangleBorder(
              //                           borderRadius:
              //                               BorderRadius.circular(3.0)),
              //                       activeSize: const Size(24.0, 5.0),
              //                       activeColor: cAccentColor,
              //                       color: Color(0xffEEEEEE),
              //                       activeShape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(3.0),
              //                       ),
              //                     ),
              //                   ));
              return   Container(

                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? mainAppColor : hintColor),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
