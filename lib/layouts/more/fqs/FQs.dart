import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava_tech/helpers/constants/DioBase.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/FQsModel.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../../../res.dart';

class FQs extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _FQsState();
  }
}
class _FQsState extends State<FQs>{


  @override
  void initState(){
    getFQs();
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
              title: Text(tr("about"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      body: Column(
        children: [
          loading ? Expanded(child: MyLoading()) :
          Container(
            height: MediaQuery.of(context).size.height-115,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: fQsModel.data.length,
              itemBuilder: (c,i){
                return InkWell(
                  onTap: (){
                    setState(() {
                      fQsModel.data[i].open = !fQsModel.data[i].open;
                    });
                  },
                  child: questionItem(
                    question: fQsModel.data[i].question,
                    answer: fQsModel.data[i].answer,
                    open: fQsModel.data[i].open,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget questionItem ({String question, answer, bool open}){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: open ? MyColors.primary : MyColors.primary.withOpacity(.2),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                border: Border.all(width: 1.5,color: MyColors.grey.withOpacity(.4))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(question,style: TextStyle(color:open ? MyColors.white : MyColors.primary,fontSize: 15,fontWeight: FontWeight.bold),),
                  Icon(open ? Icons.expand_less : Icons.expand_more,color:open ? MyColors.white : MyColors.primary,),
                ],
              ),
            ),
          ),

          open ?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
            // height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: MyColors.offWhite,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                border: Border.all(width: 1.5,color: MyColors.grey.withOpacity(.4))
            ),
            child: Text(answer,style: TextStyle(fontSize: 15,),),
          ):Container()



        ],
      ),
    );
  }

  bool loading = true;
  FQsModel fQsModel = FQsModel();
  Future getFQs() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/questions");
    try {
      final response = await http.get(url,
        headers: {"lang":preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() =>loading=false);
        print(responseData);
        if(responseData["key"]=="success"){
          fQsModel=FQsModel.fromJson(responseData);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}" );
    }
  }


}