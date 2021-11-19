import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';

import '../Home.dart';

class SuccessfulOrder extends StatefulWidget {
  @override
  _SuccessfulOrderState createState() => _SuccessfulOrderState();
}

class _SuccessfulOrderState extends State<SuccessfulOrder> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Home()), (route) => false);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.3),
                child: Container(
                    padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(.2),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(
                      Mdi.checkOutline,
                      color: MyColors.primary,
                      size: 100,
                    )),
              ),
              Text(
                tr("successOrder"),
                style: TextStyle(
                    color: MyColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              CustomButton(
                title: tr("backHome"),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) {return Home();}), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
