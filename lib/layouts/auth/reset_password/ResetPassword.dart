import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/RichTextFiled.dart';
import 'package:nava_tech/layouts/auth/login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../res.dart';

class ResetPassword extends StatefulWidget {
  final String phone;
  ResetPassword({@required this.phone});
  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {


  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _code = new TextEditingController();
  TextEditingController _new = new TextEditingController();
  TextEditingController _conform = new TextEditingController();



  // Future resetPassword() async {
  //   SharedPreferences preferences =await SharedPreferences.getInstance();
  //   if(_new.text==""||_conform.text==""){
  //     Fluttertoast.showToast(msg: "ادخل كلمة المرور الجديدة",);
  //   }else if(_new.text!=_conform.text){
  //     Fluttertoast.showToast(msg: "كلمتي المرور غير متطابقتين",);
  //   }else{
  //     LoadingDialog.showLoadingDialog();
  //     final url = Uri.https(URL, "api/forget-password");
  //     try {
  //       final response = await http.post(url,
  //         body: {
  //           "phone": "${widget.phone}",
  //           "password": "${_new.text}",
  //           "lang": "${preferences.getString("lang")}",
  //         },
  //       ).timeout( Duration(seconds: 7), onTimeout: () {throw 'no internet please connect to internet';},);
  //       final responseData = json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         EasyLoading.dismiss();
  //         print("------------ 200");
  //         print(responseData);
  //         if(responseData["key"]=="success"){
  //           print("------------ success");
  //           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Login()), (route) => false);
  //         }else{
  //           print("------------ else");
  //           Fluttertoast.showToast(
  //             msg: responseData["msg"],
  //           );
  //         }
  //       }
  //     } catch (e) {
  //       print("fail 222222222   $e}" );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.symmetric(vertical: 20),
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage(Res.logo),
                fit: BoxFit.contain,
                height: 120,
              ),
            ),

            _buildFormInputs(),
            _buildConfirmButton(false),
          ],
        ),
      ),
    );
  }



  Widget _buildFormInputs(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    RichTextFiled(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      type: TextInputType.text,
                      label: tr("confirmCode"),
                      controller: _code,
                      action: TextInputAction.next,
                    ),

                    RichTextFiled(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      type: TextInputType.text,
                      label: tr("newPass"),
                      controller: _new,
                      action: TextInputAction.next,
                    ),
                    RichTextFiled(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      type: TextInputType.text,
                      label: tr("confirmPassword"),
                      action: TextInputAction.done,
                      controller: _conform,
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool showLoading){
    return Visibility(
      child: InkWell(
        onTap: (){
          if(_code.text==""){
            Fluttertoast.showToast(msg: tr("enterCode"),);
          }else{
            resetPassword();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            "${tr("send")}",
            style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.white),
          ),
        ),
      ),
      visible: !showLoading,
      replacement: SpinKitDualRing(
        color: MyColors.primary,
        size: 30.0,
      ),
    );
  }


  Future resetPassword() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    if(_new.text==""||_conform.text==""){
      Fluttertoast.showToast(msg: "ادخل كلمة المرور",);
    }else if(_new.text!=_conform.text){
      Fluttertoast.showToast(msg: "كلمتي المرور غير متطابقتين",);
    }else{
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/reset_password");
    try {
      final response = await http.post(url,
        body: {
          "phone": "${widget.phone}",
          "reset_code": "${_code.text}",
          "password": "${_new.text}",
          "password_confirmation": "${_new.text}",
          "lang": "${preferences.getString("lang")}",
        },
      ).timeout( Duration(seconds: 7), onTimeout: () {throw 'no internet please connect to internet';},);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print("------------ 200");
        print(responseData);
        if(responseData["key"]=="success"){
          print("------------ success");
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Login()), (route) => false);
        }else{
          print("------------ else");
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}" );
    }
    }
  }


}
