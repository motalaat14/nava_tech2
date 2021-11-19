import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class MyLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SpinKitDoubleBounce(color: MyColors.primary, size: 25.0)),
          Text(tr("loading"),style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}
