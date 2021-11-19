import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class AppBarFoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 10,
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30)
        )
      ),
    );
  }
}
