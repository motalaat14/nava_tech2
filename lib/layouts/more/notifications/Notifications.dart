import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/EmptyBox.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/NotificationsModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../res.dart';

class Notifications extends StatefulWidget {

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    getNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 66),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("noti"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      loading? MyLoading():

      notificationsModel.data.data.length == 0 ?
          EmptyBox(
            widget: Container(),
            title: tr("noNoti"),
          )
          :

      ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: notificationsModel.data.data.length,
          itemBuilder: (c,i){
            return notificationItem(
              id: notificationsModel.data.data[i].id,
              title: notificationsModel.data.data[i].message,
              time: notificationsModel.data.data[i].createdAt,
            );
          }),
    );
  }

  Widget notificationItem({int id,String title,time}){
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(id.toString()),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: MyColors.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.delete,color: MyColors.red,size: 40,),
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr("deleteNoti")),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                        onPressed: () => deleteNotifications(id: id),
                        child:  Text(tr("delete"))
                    ),
                    Container(width: .5,height: 40,color: MyColors.grey,),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child:  Text(tr("cancel")),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      background: Container(
        color: MyColors.accent,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.delete_forever,color: Colors.red,size: 40,),
          ],
        ),),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: MyColors.white,
            border: Border.all(color: MyColors.accent,width: 1),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: MyColors.offWhite,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1,color: MyColors.grey),
                image: DecorationImage(image: ExactAssetImage(Res.logo,scale: 15)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: TextStyle(fontSize: 15,color: MyColors.offPrimary,fontWeight: FontWeight.bold),),
                Text(time,style: TextStyle(fontSize: 12,color: MyColors.grey,fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      ),
    );
  }


  bool loading = true;
  NotificationsModel notificationsModel = NotificationsModel();
  Future getNotifications() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/notifications");
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
          notificationsModel = NotificationsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


  Future deleteNotifications({int id}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/delete-notification");
    print(id);
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "id": id.toString(),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          getNotifications();
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      EasyLoading.dismiss();
      print("error $e" + " ==>> track $t");
    }
  }


}
