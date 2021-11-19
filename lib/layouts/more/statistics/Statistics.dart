import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../res.dart';

class Statistics extends StatefulWidget {

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  @override
  void initState() {
    getStatistics();
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
              title: Text(tr("statistics"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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
      loading?MyLoading():Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            statisticsItem(
              title: "إجمالي الطلبات",
              num: totalOrders,
            ),
            statisticsItem(
              title: "اجمالي الدخل",
              num: totalIncomes,
            ),
          ],
        ),
      ),
    );
  }

  Widget statisticsItem({String title,num}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: MyColors.primary,
        border: Border.all(color: MyColors.accent,width: 5),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,style: TextStyle(fontSize: 20,color: MyColors.white,fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(num,style: TextStyle(fontSize: 28,color: MyColors.white,fontWeight: FontWeight.bold),),
              ),
              Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.white),),
            ],
          ),
        ],
      ),
    );
  }

  String totalOrders = "";
  String totalIncomes = "";
  bool loading =true;
  Future getStatistics() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/statistics");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          print("-------------- pdf --------------");
          setState(() {
            totalOrders = responseData["data"]["totalOrders"].toString();
            totalIncomes = responseData["data"]["totalIncomes"].toString();
          });

        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

}
