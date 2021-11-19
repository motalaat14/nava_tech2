import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/WalletDetailsModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../res.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  @override
  void initState() {
    getWalletBalance();
    getWalletDetails();
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
              title: Text(tr("wallet"), style: TextStyle(fontSize: 16)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => ContactUs()));
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
      body: Column(
        children: [
          InkWell(
            onTap: (){
              getWalletPdf();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Card(
                elevation: 5,
                shape: StadiumBorder(side: BorderSide(style: BorderStyle.solid)),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text(tr("extractPDF"))),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${tr("savedMoney")} : ",
                style: TextStyle(color: MyColors.red, fontSize: 20),
              ),
              Row(
                children: [
                  Text(
                    "500",
                    style: TextStyle(
                        color: MyColors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    tr("rs"),
                    style: TextStyle(color: MyColors.red, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child:
            balanceLoading ?
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SpinKitDoubleBounce(color: MyColors.primary, size: 25.0),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    balance,
                    style: TextStyle(
                        color: MyColors.primary,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  tr("RS"),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${tr("operationsFrom")} ", style: TextStyle(fontSize: 15)),
                            Text(walletLoading ? " " : walletDetailsModel.data.firstDate, style: TextStyle(fontSize: 15)),
                            Text(" ${tr("to")} ", style: TextStyle(fontSize: 15)),
                            Text(walletLoading ? " " : walletDetailsModel.data.currentDate, style: TextStyle(fontSize: 15)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(CupertinoIcons.calendar),
                            )
                          ],
                        )),
                  ),


          walletLoading ?
          Container(
              height: MediaQuery.of(context).size.height*.5,
              child: SpinKitDoubleBounce(color: MyColors.primary, size: 25.0))
              :
          table(),

          CustomButton(
            title: tr("charge"),
            onTap: (){},
            margin: EdgeInsets.symmetric(horizontal: 15),
          ),

        ],
      ),
    );
  }

  Widget table(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
            ),
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(tr("dateAndNum"), style: TextStyle(fontSize: 12),),
                VerticalDivider(color: MyColors.white,width: 2,thickness: 1,endIndent: 5,indent: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("type"), style: TextStyle(fontSize: 14),),
                ),
                VerticalDivider(color: MyColors.white,width: 2,thickness: 1,endIndent: 5,indent: 5),
                Text(tr("addOrMinus"), style: TextStyle(fontSize: 12),),
                VerticalDivider(color: MyColors.white,width: 2,thickness: 1,endIndent: 5,indent: 5),
                Text(tr("balance"), style: TextStyle(fontSize: 14),),
              ],
            ),
          ),


          Container(
            height: MediaQuery.of(context).size.height*.4,
            child: ListView.builder(
              itemCount: 40,
                itemBuilder: (c,i)=>tableItem(
                  index: i,
                  date: "24-9-2021",
                  orderNum: "1607718",
                  type: "لوحة كهربا",
                  addOrMinus: "850",
                  balance: "1240"
                )),
          )

        ],
      ),
    );
  }

  Widget tableItem({int index,String date,orderNum,type,addOrMinus,balance}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: index.isOdd?MyColors.greyWhite:MyColors.white,
        border: Border.all(width: .2)
      ),
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date, style: TextStyle(fontSize: 14),),
              Text(orderNum, style: TextStyle(fontSize: 14,color: MyColors.offPrimary,fontWeight: FontWeight.bold),),
            ],
          ),
          VerticalDivider(color: MyColors.black,width: 2,thickness: 1,endIndent: 5,indent: 5),
          Text(type, style: TextStyle(fontSize: 14),),
          VerticalDivider(color: MyColors.black,width: 2,thickness: 1,endIndent: 5,indent: 5),
          Text(addOrMinus, style: TextStyle(fontSize: 15),),
          VerticalDivider(color: MyColors.black,width: 2,thickness: 1,endIndent: 5,indent: 5),
          Text(balance, style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }


  String balance = "";
  bool balanceLoading = true;
  Future getWalletBalance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/wallet");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => balanceLoading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          setState(() {
            balance=responseData["data"].toString();
          });
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


  bool walletLoading = true;
  WalletDetailsModel walletDetailsModel = WalletDetailsModel();
  Future getWalletDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/tech-wallet");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => walletLoading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          walletDetailsModel = WalletDetailsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future getWalletPdf() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/download-pdf");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // setState(() => walletLoading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          print("-------------- pdf --------------");
          // walletDetailsModel = WalletDetailsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


}
