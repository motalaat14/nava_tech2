import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/layouts/auth/login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res.dart';
import 'package:http/http.dart'as http;

class ActiveAccount extends StatefulWidget {
  final String phone,code;

  const ActiveAccount({Key key, this.phone, this.code}) : super(key: key);

  @override
  _ActiveAccountState createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {



  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  TextEditingController code=new TextEditingController();

  @override
  void initState() {
    print(widget.phone);
    print(widget.phone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 50),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage(Res.logo),
                fit: BoxFit.contain,
                height: 120,
              ),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr("activeAccount"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(tr("willSendSMS"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10),
                  child: PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    appContext: context,
                    length: 4,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 55,
                      fieldWidth: 45,
                      activeFillColor: MyColors.secondary,
                      selectedColor: MyColors.primary,
                      activeColor: MyColors.primary,
                      inactiveColor: MyColors.grey.withOpacity(.4),
                      inactiveFillColor:MyColors.grey.withOpacity(.5),
                      selectedFillColor: MyColors.primary.withOpacity(.2)
                    ),
                    keyboardType: TextInputType.number,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: code,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),


                CustomButton(
                  title: tr("confirm"),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                  onTap: (){
                    activeAccount();
                  },
                ),


                InkWell(
                  onTap: (){
                    resendCode();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr("codeNotSent"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: MyColors.primary),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(tr("resend"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: MyColors.offPrimary,decoration: TextDecoration.underline),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future activeAccount() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("========> activeAccount");
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/active-code");
    try {
      final response = await http.post(url,
        body: {
          "phone": "${widget.phone}",
          "code": "${code.text}",
          "uuid":preferences.getString("uuid"),
          "device_id": preferences.getString("fcmToken"),
          "device_type": Platform.isIOS ?"ios":"android",
          "lang":preferences.getString("lang"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if(responseData["key"]=="success"){
          Fluttertoast.showToast(msg: tr("registerSuc"));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Login()), (route) => false,);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("fail 222222222   $e}" );
    }
  }

  Future resendCode() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("========> resendCode");
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/resend_code");
    try {
      final response = await http.post(url,
        body: {
          "type":"activation",
          "phone": "${widget.phone}",
          "device_id": preferences.getString("fcmToken"),
          "device_type": Platform.isIOS ?"ios":"android",
          "lang":preferences.getString("lang"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if(responseData["key"]=="success"){
          Fluttertoast.showToast(msg: responseData["msg"]);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("fail 222222222   $e}" );
    }
  }

}
