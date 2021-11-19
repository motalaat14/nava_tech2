import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava_tech/helpers/constants/DioBase.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/Badge.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/TermsModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class Terms extends StatefulWidget {
  final String from;

  const Terms({Key key, this.from}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TermsState();
  }
}

class _TermsState extends State<Terms> {
  String desc;
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("terms"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      key: _scaffold,
      body: loading
          ? MyLoading()
          : Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Column(
              children: [
                Text(
                  termsModel.data.desc,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.3
                  ),
                ),
              ],
            ),
          )),
    );
  }

  bool loading = true;
  TermsModel termsModel = TermsModel();
  Future getTerms() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("========> login");
    print(preferences.getString("fcmToken"));
    final url = Uri.https(URL, "api/policy");
    try {
      final response = await http.post(url,
        body: {"lang":preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() =>loading=false);
        print(responseData);
        if(responseData["key"]=="success"){
          termsModel=TermsModel.fromJson(responseData);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}" );
    }
  }


// DioBase dioBase = DioBase();
// Future getTerms() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   Map<String, String> headers = {
//     "Authorization": "Bearer ${preferences.getString("token")}"
//   };
//   dioBase
//       .get("policy", headers: headers)
//       .then((response) {
//     if (response.data["key"] == "success") {
//       setState(() {
//         loading = false;
//       });
//       desc = response.data["data"]["termsConditions"];
//     } else {
//       print("------------------------else");
//       Fluttertoast.showToast(msg: response.data["msg"]);
//     }
//   });
// }
}
