import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/LabelTextField.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import '../../../res.dart';
import '../Home.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/layouts/Home/orders/SuccessfulOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RejectReason extends StatefulWidget {
  final int id;

  const RejectReason({Key key, this.id}) : super(key: key);

  @override
  _RejectReasonState createState() => _RejectReasonState();
}

class _RejectReasonState extends State<RejectReason> {
  TextEditingController _reason = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("rejectReason"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*.88,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              LabelTextField(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                label: tr("writeRejectReason"),
                type: TextInputType.text,
                lines: 22,
                controller: _reason,
              ),

              CustomButton(
                margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                title: tr("send"),
                onTap: (){
                  
                  if(_reason.text!=""){
                    rejectOrder();
                  }else{
                    Fluttertoast.showToast(msg: tr("writeRejectReason"));
                  }
                  },
              ),

            ],
          ),
        ),
      ),

    );
  }


  Future rejectOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/refuse-order");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": "${widget.id}",
          "notes": _reason.text,
        },
      ).timeout(Duration(seconds: 10), onTimeout: ()=>throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
          Fluttertoast.showToast(msg: tr("orderRejected"));
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }



}
