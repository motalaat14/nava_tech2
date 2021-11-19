import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nava_tech/helpers/constants/DioBase.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/Badge.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/customs/RichTextFiled.dart';
import 'package:nava_tech/helpers/models/ProfileModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import 'change_password.dart';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  // final String name, phone, email, img;
  // const Profile({Key key, this.name, this.phone, this.email, this.img});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController mail = new TextEditingController();
  String img;

  // initInfo() {
  //   name.text = widget.name;
  //   phone.text = widget.phone;
  //   mail.text = widget.email;
  //   img = widget.img;
  // }

  @override
  void initState() {
    // initInfo();
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: MyColors.secondary,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("profile"), style: TextStyle(fontSize: 16)),
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
      body:


      loading ?
      MyLoading()
          :
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: InkWell(
                    onTap:(){
                      _openImagePicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              color: MyColors.primary.withOpacity(.2),
                              borderRadius: BorderRadius.circular(100),
                              border:Border.all(width: 2,color: MyColors.primary),
                              image: DecorationImage(image:
                              imageFile!=null?FileImage(imageFile):
                              NetworkImage(profileModel.data.avatar),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                        Container(
                          width: 30,
                          height:30,
                          decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(50),
                              border:Border.all(width: 1,color: MyColors.primary)
                          ),
                          child: Icon(Icons.camera_alt_outlined,size: 20,color: MyColors.white,),
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr("name"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: name,
                          label: tr("name"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                        Text(tr("mail"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: mail,
                          label: tr("mail"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                        Text(tr("phone"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: phone,
                          label: tr("phone"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  CustomButton(
                    title: tr("changePass"),
                    textColor: MyColors.primary,
                    margin: EdgeInsets.symmetric(vertical: 0),
                    color: MyColors.white,
                    borderColor: MyColors.primary,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>ChangePassword()));
                    },
                  ),
                  CustomButton(
                    title: tr("saveChanges"),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    onTap: (){
                      updateProfile();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  File imageFile;
  final picker = ImagePicker();
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }
  void _openImagePicker(BuildContext context) {
    print("-------------_openImagePicker");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(tr("cancel"),
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("selectImg"),
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              FlatButton(
                child: Text(
                  tr("fromCam"),
                ),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              FlatButton(
                child: Text(tr("fromGallery")),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  bool loading = true;
  ProfileModel profileModel =ProfileModel();
  Future getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/profile");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          profileModel = ProfileModel.fromJson(responseData);
          setState(() {
            name=TextEditingController(text: profileModel.data.name);
            mail=TextEditingController(text: profileModel.data.email);
            phone=TextEditingController(text: profileModel.data.phone);
          });
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  DioBase dioBase = DioBase();
  Future updateProfile() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {"Authorization": "Bearer ${preferences.getString("token")}"};
    print(" ----------image > $imageFile");
    FormData bodyData = FormData.fromMap({
      "lang": preferences.getString("lang"),
      "name": name.text,
      "email": mail.text,
      "phone": phone.text,
      "_avatar": imageFile == null ? null : MultipartFile.fromFileSync(imageFile.path,
          filename: "${imageFile.path.split('/').last}"),
    });
    dioBase.post("profile/update", body: bodyData, headers: headers).then((response) {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (response.data["key"] == "success") {
          Fluttertoast.showToast(msg: response.data["msg"]);

          preferences.setString("name", response.data["data"]["user"]["name"]);
          preferences.setString("phone", response.data["data"]["user"]["phone"]);
          preferences.setString("email", response.data["data"]["user"]["email"]);
          // preferences.setString("token", response.data["data"]["token"]);
          preferences.setString("image", response.data["data"]["user"]["avatar"]);


          print("--------profile update success--------");
        } else {
          EasyLoading.dismiss();
          print("---------------------------------------else else");
          Fluttertoast.showToast(msg: response.data["msg"]);
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg: response.data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }




}
