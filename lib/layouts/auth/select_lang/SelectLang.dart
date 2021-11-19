import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/layouts/auth/login/Login.dart';
import 'package:nava_tech/layouts/auth/register/Register.dart';
import 'package:nava_tech/layouts/auth/welcome/Welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class SelectLang extends StatefulWidget {

  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {

  String uuid ;
  void getUuid()async{
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("uuid get token >>>> ${preferences.getString("fcmToken")}");
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if(Platform.isAndroid){
      var build = await deviceInfoPlugin.androidInfo;
      uuid = build.androidId;
      preferences.setString("uuid", uuid);
    }else if(Platform.isIOS){
      var data = await deviceInfoPlugin.iosInfo;
      uuid = data.identifierForVendor;
      preferences.setString("uuid", uuid);
    }
  }


  static void  changeLanguage(String lang,BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang == "en") {
      prefs.setString("lang", lang);
      context.locale = Locale('en', 'US');
    }else if (lang == "ur") {
      prefs.setString("lang", lang);
      context.locale = Locale('ur', 'UR');
    } else {
      context.locale=Locale('ar', 'EG');
      prefs.setString("lang", lang);
    }
  }


  @override
  void initState() {
    getUuid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(image: ExactAssetImage(Res.splash),fit: BoxFit.cover)
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50,horizontal: 15),
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage(Res.logo),scale: 5)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr("lang"),style: TextStyle(fontSize: 22,color: MyColors.primary),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(tr("selectLang"),style: TextStyle(fontSize: 16,color: MyColors.offPrimary),),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomButton(
                        title: tr("ar"),
                        onTap: (){
                          changeLanguage("ar", context);
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>Login()));
                        },
                    ),
                  ),

                  CustomButton(
                    title: tr("en"),
                    textColor: MyColors.primary,
                    color: MyColors.secondary,
                    borderColor: MyColors.primary,
                    onTap: (){
                      changeLanguage("en", context);
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>Login()));
                    },
                  ),


                  CustomButton(
                    title: tr("urdu"),
                    onTap: (){
                      changeLanguage("ur", context);
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>Login()));
                    },
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
