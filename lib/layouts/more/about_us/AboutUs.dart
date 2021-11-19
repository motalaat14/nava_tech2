import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava_tech/helpers/constants/DioBase.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/AboutModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isLoading = true;
  String desc ;

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("about"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) => ContactUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      image: ExactAssetImage(Res.contactus),
                      width: 26,
                    ),
                  ),
                )
              ],
            ),
            AppBarFoot(),
          ],
        ),
      ),


      body:
      loading ?
      MyLoading()
          : Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            child: Column(
              children: [
                Text(
                  aboutModel.data.desc,
                  style: TextStyle(
                      fontSize: 15,
                      height: 1.3
                  ),
                ),
              ],
            ),
          )),
    );
  }






  bool loading =true;
  AboutModel aboutModel = AboutModel();
  Future getAbout() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/about");
    try {
      final response = await http.get(url,
          // body: {"lang":preferences.getString("lang")},
          headers: {"lang":preferences.getString("lang")}
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() =>loading=false);
        print(responseData);
        if(responseData["key"]=="success"){
          aboutModel=AboutModel.fromJson(responseData);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}" );
    }
  }


}
