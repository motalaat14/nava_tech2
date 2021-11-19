import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget{

  String title;
  Function onTap;
  Color textColor;
  Color color;
  Color borderColor;
  BorderRadius borderRadius;
  EdgeInsets margin;
  double width;
  double height;
  double textSize;
  IconData icon;

  CustomButton({@required this.title,@required this.onTap,
    this.color,this.textColor,this.borderRadius,this.margin,this.borderColor,
    this.height,
    this.width,this.icon,this.textSize});

  @override
  Widget build(BuildContext context) {
    Color border=color??MyColors.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width?? MediaQuery.of(context).size.width,
        height: height??50,
        margin: margin?? EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color??MyColors.primary,
          borderRadius: borderRadius?? BorderRadius.circular(15),
          border: Border.all(color: borderColor??border,width: 2)
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!=null?Icon(icon,color: textColor??MyColors.white,):Container(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("$title",
                style: TextStyle(
                fontSize: textSize??18,
                color: textColor??MyColors.white,
                fontWeight: FontWeight.bold,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

}