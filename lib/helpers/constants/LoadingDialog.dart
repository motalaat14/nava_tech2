import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nava_tech/layouts/auth/login/Login.dart';

import 'MyColors.dart';

class LoadingDialog {
  static showLoadingDialog() {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none,
        dismissOnTap: false,
        indicator: SpinKitCubeGrid(
          size: 45.0,
          itemBuilder: (context, index) {
            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: MyColors.accent, shape: BoxShape.circle),
            );
          },
        ),
        status: tr("loading"));
  }

  static showLoadingView() {
    return SpinKitCubeGrid(
      color: MyColors.primary,
      size: 40.0,
    );
  }

  static showConfirmDialog(
      {@required BuildContext context,
      @required String title,
      @required Function confirm}) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return _alertDialog(title, confirm, context, "تأكيد");
      },
    );
  }

  static showAuthDialog({@required BuildContext context}) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return _alertDialog(
            "قم بتسجيل الدخول للمتابعة",
            () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Login()), (route) => false),
            context,
            "دخول");
      },
    );
  }

  static Widget _alertDialog(
      String title, Function confirm, BuildContext context, String okText) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle( fontSize: 12,
          color: MyColors.black),
      ),
      content: Text(title,style : TextStyle(fontSize: 12,color: MyColors.blackOpacity)),
      actions: [
        CupertinoDialogAction(
          child: Text(
            "رجوع",
            style: TextStyle(
            fontSize: 12,
            color: MyColors.blackOpacity,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text(
            okText,
            style: TextStyle(
              fontSize: 12,
              color: MyColors.blackOpacity,
            ),
          ),
          onPressed: confirm,
        ),
      ],
    );
  }

  // static showToastNotification(msg,
  //     {Color color, Color textColor, Alignment alignment}) {
  //   BotToast.showSimpleNotification(
  //       title: msg,
  //       align: alignment ?? Alignment.bottomCenter,
  //       backgroundColor: color ?? MyColors.grey.withOpacity(.9),
  //       titleStyle: TextStyle(color: textColor ?? MyColors.white),
  //       duration: Duration(seconds: 3),
  //       hideCloseButton: false,
  //       closeIcon: Icon(
  //         Icons.close,
  //         size: 25,
  //         color: MyColors.accent,
  //       ));
  // }

  // static showSimpleToast(msg) {
  //   BotToast.showText(text: msg,duration: Duration(seconds: 1),textStyle: TextStyle(fontSize: 15,color: MyColors.white));
  // }
}
