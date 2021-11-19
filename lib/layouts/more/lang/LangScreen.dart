import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/customs/Badge.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/layouts/auth/splash/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../res.dart';

class LangScreen extends StatefulWidget {
  @override
  _LangScreenState createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  @override
  void initState() {
    initLang();
    // getNotificationCount();
    super.initState();
  }

  int count = 0;
  // Future getNotificationCount() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.https(URL, "api/unread-notifications-count");
  //   try {
  //     final response = await http.post(url, body: {
  //       "lang": "${preferences.getString("lang")}"
  //     }, headers: {
  //       "Authorization": "Bearer ${preferences.getString("token")}"
  //     }).timeout(
  //       Duration(seconds: 7),
  //       onTimeout: () {
  //         throw 'no internet please connect to internet';
  //       },
  //     );
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         setState(() {
  //           count = responseData["data"]["count"];
  //         });
  //         print(
  //             "---------------------------------------success notifications count");
  //         print(count);
  //         print(
  //             "---------------------------------------success notifications count");
  //       } else {
  //         // Fluttertoast.showToast(
  //         //   msg: responseData["msg"],
  //         //   toastLength: Toast.LENGTH_SHORT,
  //         //   gravity: ToastGravity.CENTER,
  //         // );
  //       }
  //     }
  //   } catch (e) {
  //     print("fail 222222222   $e}");
  //   }
  // }

  String lang;
  bool ar = true;
  initLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
    setState(() {
      lang = preferences.getString("lang");
    });
    if(preferences.getString("lang")=="ar"){
      setState(() {
        ar=true;
      });
    }else{
      setState(() {
        ar=false;
      });
    }
  }

  changeLangPref({@required String newLang}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lang", newLang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(
          tr("appLang"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        actions: [
          InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Badge(
                  value: "3",
                  color: MyColors.red,
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: MyColors.offPrimary,
                      size: 28,
                    ),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
                    },
                  )),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                tr("appLang"),
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: MyColors.offPrimary),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  tr("plzSelectLang"),
                  style: TextStyle(fontSize: 16,color: MyColors.primary),
                ),
              ),
              InkWell(
                  onTap: () {
                    if (!ar) {
                      setState(() {
                        ar = true;
                        lang="ar";
                      });
                    }
                    print(lang);
                  },
                  child: langItem(
                    lang: "اللغة العربية",
                    img: Res.saudiarabia,
                    selected: ar,
                  )),
              InkWell(
                  onTap: () {
                    if (ar) {
                      setState(() {
                        ar = false;
                        lang="en";
                      });
                    }
                    print(lang);
                  },
                  child: langItem(
                    lang: "English",
                    img: Res.usa,
                    selected: !ar,
                  ),
              ),
              Spacer(),
              CustomButton(
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                  title: tr("confirm"),
                  onTap: (){
                  changeLangPref(newLang: lang);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Splash()),
                          (route) => false);
                  Fluttertoast.showToast(
                    msg: tr("langChanged"),
                  );
                  },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget langItem({String lang, img, bool selected}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * .8,
      height: 110,
      decoration: BoxDecoration(
        color: selected?MyColors.accent.withOpacity(.2):MyColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? MyColors.accent : MyColors.grey.withOpacity(.2), width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(img),
            width: 40,
          ),
          Text(lang,
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
