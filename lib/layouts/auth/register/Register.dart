// import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
// import 'package:nava_tech/helpers/constants/MyColors.dart';
// import 'package:nava_tech/helpers/constants/base.dart';
// import 'package:nava_tech/helpers/customs/CustomButton.dart';
// import 'package:nava_tech/helpers/customs/RichTextFiled.dart';
// import 'package:nava_tech/layouts/auth/active_account/ActiveAccount.dart';
// import 'package:nava_tech/layouts/auth/login/Login.dart';
// import 'package:http/http.dart'as http;
// import 'package:nava_tech/layouts/more/terms/Terms.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../res.dart';
//
// class Register extends StatefulWidget {
//
//   @override
//   _RegisterState createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//   GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
//   GlobalKey<FormState> _formKey=new GlobalKey();
//   TextEditingController name=new TextEditingController();
//   TextEditingController phone=new TextEditingController();
//   TextEditingController mail=new TextEditingController();
//   TextEditingController bank=new TextEditingController();
//   TextEditingController pass=new TextEditingController();
//   TextEditingController pass2=new TextEditingController();
//   bool terms = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffold,
//       backgroundColor: MyColors.secondary,
//       body: Center(
//         child: ListView(
//           physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 50),
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 30,bottom: 20),
//                   child: Image(
//                     image: AssetImage(Res.logo),
//                     fit: BoxFit.contain,
//                     height: 120,
//                   ),
//                 ),
//
//                 Text(tr("register"),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: MyColors.offPrimary,),),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(tr("joinUs"),style: TextStyle(fontSize: 12,color: MyColors.grey,),),
//                 ),
//
//                 Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichTextFiled(
//                           controller: name,
//                           label: tr("name"),
//                           type: TextInputType.name,
//                           margin: EdgeInsets.only(top: 15,),
//                           action: TextInputAction.next,
//                         ),
//                         RichTextFiled(
//                           controller: phone,
//                           label: tr("phone"),
//                           type: TextInputType.phone,
//                           margin: EdgeInsets.only(top: 15,),
//                           icon: Container(
//                             width: 90,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Image(image: ExactAssetImage(Res.saudiarabia),width: 30,),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                                   child: Text("996+",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         RichTextFiled(
//                           controller: mail,
//                           label: "${tr("mail")} ( ${tr("optional")} )",
//                           type: TextInputType.emailAddress,
//                           margin: EdgeInsets.only(top: 15,),
//                         ),
//                         RichTextFiled(
//                           controller: pass,
//                           label: tr("password"),
//                           type: TextInputType.text,
//                           margin: EdgeInsets.only(top: 15,),
//                           icon: Icon(Icons.visibility_rounded,color: MyColors.grey.withOpacity(.6),),
//                         ),
//                         RichTextFiled(
//                           controller: pass2,
//                           label: tr("confirmPassword"),
//                           type: TextInputType.text,
//                           margin: EdgeInsets.only(top: 15,),
//                           icon: Icon(Icons.visibility_rounded,color: MyColors.grey.withOpacity(.6),),
//                         ),
//
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: Row(
//                             children: [
//                               InkWell(
//                                   onTap: (){
//                                     setState(() {
//                                       terms =! terms;
//                                     });
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                                     child: Icon(terms ?Icons.check_box_rounded:Icons.check_box_outline_blank,color: MyColors.primary,size: 28,),
//                                   )),
//                               InkWell(
//                                   onTap:(){
//                                     Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Terms(from: "register",)));
//                                   },
//                                   child: Text(tr("acceptTerms"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: MyColors.offPrimary,decoration: TextDecoration.underline,),)),
//                             ],
//                           ),
//                         ),
//
//                         CustomButton(
//                           title: tr("register"),
//                           margin: EdgeInsets.symmetric(vertical: 24),
//                           onTap: (){
//                             if(terms){
//                               if(pass.text==pass2.text&&pass.text!=""){
//                                 register();
//                               }else{
//                                 Fluttertoast.showToast(msg: tr("unMatchPass"),);
//                               }
//                             }else{
//                               Fluttertoast.showToast(msg: tr("plzAcceptTerms"),);
//                             }
//                           },
//                         ),
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width*.3,
//                               height: 2,
//                               color: MyColors.grey.withOpacity(.4),
//                             ),
//
//                             Text(tr("haveAccount"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: MyColors.offPrimary,),),
//
//                             Container(
//                               width: MediaQuery.of(context).size.width*.3,
//                               height: 2,
//                               color: MyColors.grey.withOpacity(.4),
//                             ),
//                           ],
//                         ),
//
//                         CustomButton(
//                           title: tr("login"),
//                           color: MyColors.secondary,
//                           borderColor: MyColors.primary,
//                           textColor: MyColors.primary,
//                           margin: EdgeInsets.symmetric(vertical: 24),
//                           onTap: (){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
//                           },
//                         ),
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Future register() async {
//     SharedPreferences preferences =await SharedPreferences.getInstance();
//     print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyy sign-up");
//     LoadingDialog.showLoadingDialog();
//     final url = Uri.https(URL, "api/client_sign_up");
//     print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyy sign-up 111");
//     try {
//       final response = await http.post(url,
//         body: {
//           "name":"${name.text}",
//           "phone": "${phone.text}",
//           "password": "${pass.text}",
//           "password_confirmation": "${pass.text}",
//           "commercial_acc": "${bank.text}",
//           "email": "${mail.text}",
//           "lang":preferences.getString("lang"),
//         },
//       ).timeout(
//         Duration(seconds: 7),
//         onTimeout: () {throw 'no internet please connect to internet';},
//       );
//       final responseData = json.decode(response.body);
//       if (response.statusCode == 200) {
//         EasyLoading.dismiss();
//         print(responseData);
//         if(responseData["key"]=="success"){
//           Fluttertoast.showToast(msg: tr("loginSuccessPlzActive"));
//           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>ActiveAccount(phone: phone.text,code: responseData["data"]["active_code"],)), (route) => false,);
//         }else{
//           Fluttertoast.showToast(msg: responseData["msg"]);
//         }
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       print("fail 222222222   $e}" );
//     }
//     // }else{}
//   }
//
//
//
// }
