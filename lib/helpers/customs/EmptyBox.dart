import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import '../../res.dart';

class EmptyBox extends StatelessWidget {
  final String title;
  final Widget widget;

  const EmptyBox({Key key, this.title, this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            child: Lottie.asset(
                // "assets/animations/empty02.json",
              Res.empty
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              title,
              style: TextStyle(
                color: MyColors.offPrimary,
              fontWeight: FontWeight.bold,
              )
            ),
          ),
          widget??null,
        ],
      ),
    );
  }
}
