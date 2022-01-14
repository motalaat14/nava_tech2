import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/LabelTextField.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import 'SuccessfulOrder.dart';

class OrderNoticesScreen extends StatefulWidget {
  final int id;
  OrderNoticesScreen({this.id});

  @override
  State<OrderNoticesScreen> createState() => _OrderNoticesScreenState();
}

class _OrderNoticesScreenState extends State<OrderNoticesScreen> {
  final TextEditingController noticesController = new TextEditingController();
  final TextEditingController total = new TextEditingController();

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
              title: Text('اضافة فاتورة',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelTextField(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                label: 'ادخل الملاحظات',
                type: TextInputType.text,
                lines: 16,
                controller: noticesController,
              ),
              LabelTextField(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                label: 'ادخل المبلغ بالريال السعودي',
                type: TextInputType.number,
                lines: 2,
                controller: total,
              ),
              CustomButton(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                title: tr("send"),
                onTap: () {
                  if (noticesController.text != "" && total.text != "") {
                    addNotices();
                  } else {
                    Fluttertoast.showToast(msg: ' يرجي ملئ الملاحظات والمبلغ');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addNotices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/add-bill-notes");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": "${widget.id}",
          "notes": noticesController.text,
          "price": total.text,
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => SuccessfulOrder()));
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}
