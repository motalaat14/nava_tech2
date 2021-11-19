import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/DioBase.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/RichTextFiled.dart';
import 'package:nava_tech/helpers/providers/FcmTokenProvider.dart';
import 'package:nava_tech/layouts/Home/Home.dart';
import 'package:nava_tech/layouts/auth/active_account/ActiveAccount.dart';
import 'package:nava_tech/layouts/auth/forget_password/ForgetPassword.dart';
import 'package:provider/provider.dart';
// import 'package:nava_tech/layouts/home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../res.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController _phone=new TextEditingController();
  TextEditingController _pass=new TextEditingController();
  bool pass=true;

  @override
  void initState() {
    initLang();
    super.initState();
  }
  
  initLang()async{
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: MyColors.offWhite,
      appBar: AppBar(
        backgroundColor: MyColors.offWhite,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Image(
              image: AssetImage(Res.logo),
              fit: BoxFit.contain,
              height: 120,
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(tr("welcomeBack"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: MyColors.offPrimary,),),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(tr("loginWithUs"),style: TextStyle(fontSize: 14,color: MyColors.grey,),),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichTextFiled(
                  controller: _phone,
                  label: tr("phone"),
                  type: TextInputType.phone,
                  margin: EdgeInsets.only(top: 20,bottom: 10),
                  fillColor: MyColors.secondary.withOpacity(.5),
                  action: TextInputAction.next,
                ),

                RichTextFiled(
                  controller: _pass,
                  pass: pass,
                  label: tr("password"),
                  type: TextInputType.emailAddress,
                  margin: EdgeInsets.only(top: 12,bottom: 25),
                  fillColor: MyColors.secondary.withOpacity(.5),
                  icon: IconButton(icon:Icon(Icons.visibility_rounded),color: MyColors.grey.withOpacity(.6), onPressed: (){setState(() {pass=!pass;});},),
                ),


                InkWell(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>ForgetPassword()));
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                      child: Text(tr("forgetPassword"),style: TextStyle(fontSize: 13,color: MyColors.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),)),
                ),


                loading?
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: SpinKitDoubleBounce(color: MyColors.accent, size: 30.0))
                    :
                CustomButton(
                    title: tr("login"),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                    onTap: (){
                      if(_pass.text!="" && _phone.text!=""){
                        login();
                      }else{
                        Fluttertoast.showToast(msg: tr("plzFillData"),);
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  bool loading=false;
  DioBase dioBase = DioBase();

  Future login() async {
    setState(()=>loading=true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("========> login01");
    FcmTokenProvider fcmTokenProvider = Provider.of<FcmTokenProvider>(context,listen: false);
    print(fcmTokenProvider.fcmToken);
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
    print("========> login02");
    FormData bodyData = FormData.fromMap({
      "lang":preferences.getString("lang"),
      "phone": "${_phone.text}",
      "password": "${_pass.text}",
      "device_id": fcmTokenProvider.fcmToken,
      "device_type": Platform.isIOS ?"ios":"android",
      "uuid":preferences.getString("uuid"),
    });
    print("========> login03");
    dioBase.post("tech-sign-in", body: bodyData).then((response) {
      print("========> login04");
      if (response.statusCode == 200) {
        print("========> login05");
        setState(() => loading = false);
        if (response.data["key"] == "success") {
          print("========> login06");
          preferences.setString("userId", response.data["data"]["user"]["id"].toString());
          preferences.setString("name", response.data["data"]["user"]["name"]);
          preferences.setString("phone", response.data["data"]["user"]["phone"]);
          preferences.setString("email", response.data["data"]["user"]["email"]);
          preferences.setString("token", response.data["data"]["token"]);
          preferences.setString("image", response.data["data"]["user"]["avatar"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c) => Home()), (route) => false,);
        } else if (response.data["key"] == "not_active") {
          Fluttertoast.showToast(msg: response.data["msg"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c) => ActiveAccount(phone: _phone.text,)), (
              route) => false,);
        } else {
          print("========> login08");
          Fluttertoast.showToast(msg: response.data["msg"]);
        }
      }else{
        setState(() => loading = false);
        Fluttertoast.showToast(msg: response.data["msg"]);
      }
    });
  }


}
