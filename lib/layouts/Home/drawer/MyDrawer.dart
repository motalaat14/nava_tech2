import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/providers/FcmTokenProvider.dart';
import 'package:nava_tech/layouts/auth/splash/Splash.dart';
import 'package:nava_tech/layouts/more/about_us/AboutUs.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:nava_tech/layouts/more/fqs/FQs.dart';
import 'package:nava_tech/layouts/more/notifications/Notifications.dart';
import 'package:nava_tech/layouts/more/profile/Profile.dart';
import 'package:nava_tech/layouts/more/statistics/Statistics.dart';
import 'package:nava_tech/layouts/more/terms/Terms.dart';
import 'package:nava_tech/layouts/more/wallet/Wallet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

import '../../../res.dart';

class MyDrawer extends StatefulWidget {
  final String name,img,phone;
  const MyDrawer({Key key, this.name,this.img, this.phone}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    initLang();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .78,
      child: Drawer(
        elevation: 5,
        child: new ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              ),
              child: new DrawerHeader(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(),
                              image: DecorationImage(image: NetworkImage(widget.img),fit: BoxFit.cover)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(widget.phone, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: ()=>logout(context),
                        child: Icon(Mdi.logout,size: 40,color: MyColors.white,)),//red
                  ],
                ),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.accent.withOpacity(.3),width: 1.5))),
              ),
            ),
            new ListTile(
                leading: new Icon(CupertinoIcons.home,color: MyColors.black,size: 28,),
                trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
                title: Text(tr("main"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
                onTap: () {
                  Navigator.of(context).pop();
                },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.profile_circled,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("profile"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>Profile()));
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(Mdi.walletOutline,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("wallet"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Wallet()));
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.chart_bar,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("statistics"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Statistics()));
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.bell,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("noti"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Notifications()));
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.globe,color: MyColors.black,size: 28,),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr("lang"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
                  Row(
                    children: [
                      Text(language=="en" ? tr("en") : language=="ar" ? tr("ar") : tr("lang"),style: TextStyle(fontSize: 15,),),
                      Icon(Icons.expand_more_outlined,),
                    ],
                  ),
                ],
              ),
              onTap: () {
                changLang(context);
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Image(image: ExactAssetImage(Res.contactus),width: 26,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("contactUs"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ContactUs()));
              },
            ),
            Divider(thickness: 2,height: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.question_circle,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("fqs"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>FQs()));
              },
            ),
            Divider(thickness: 2,color: MyColors.secondary,),

            new ListTile(
              leading: new Icon(CupertinoIcons.exclamationmark_circle,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("about"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>AboutUs()));
              },
            ),

            Divider(thickness: 2,color: MyColors.secondary,),
            new ListTile(
              leading: new Icon(CupertinoIcons.square_list,color: MyColors.black,size: 28,),
              trailing: new Icon(Icons.arrow_forward_ios,color: MyColors.black,),
              title: Text(tr("terms"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Terms()));
              },
            ),

          ],
        ),
      ),
    );
  }


  void changLang(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: CupertinoActionSheet(
              cancelButton: CupertinoButton(
                child: Text(
                  tr("cancel"),
                  style: TextStyle(
                      fontFamily: GoogleFonts.almarai().fontFamily,
                      color: MyColors.red),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("selectLang"),
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(tr("ar"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  onPressed: () {
                    changeLanguage("ar",context);
                  },
                ),
                FlatButton(
                  child: Text(tr("en"),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                  onPressed: () {
                    changeLanguage("en",context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String language;
  initLang()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("lang") == "en") {
      print("------- en");
      setState(() {
        language="en";
      });
    } else {
      print("------- ar");
      setState(() {
        language="ar";
      });
    }
  }
  static void  changeLanguage(String lang,BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang == "en") {
      prefs.setString("lang", lang);
      context.locale = Locale('en', 'US');
      Navigator.pop(context);
    } else {
      context.locale = Locale('ar', 'EG');
      prefs.setString("lang", lang);
      Navigator.pop(context);
    }
  }


  String uuid;
  void getUuid() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      uuid = build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      uuid = data.identifierForVendor;
    }
  }
  Future logout(BuildContext context) async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FcmTokenProvider fcmTokenProvider = Provider.of<FcmTokenProvider>(context,listen: false);
    print("${preferences.getString("fcmToken")}");
    print("$uuid");
    final url = Uri.https(URL, "api/logout");
    try {final response = await http.post(url,
      body: {
        "uuid": "$uuid",
        "device_id": fcmTokenProvider.fcmToken,
      },).timeout(Duration(seconds: 7),
      onTimeout: () {throw 'no internet please connect to internet';},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print("------------ 200");
      print(responseData);
      if (responseData["key"] == "success") {

        preferences.remove("fcmToken");
        preferences.remove("userId");
        preferences.remove("token");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Splash()), (route) => false);
      } else {
        print("------------ else");
        Fluttertoast.showToast(msg: responseData["msg"]);
      }
    }
    } catch (e) {
      print("fail 222222222   $e}");
    }
  }

}
