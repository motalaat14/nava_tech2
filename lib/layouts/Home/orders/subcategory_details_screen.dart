import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/add_to_cart_model.dart';
import 'package:nava_tech/helpers/models/subcategory_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home.dart';

class SubCategoryDetails extends StatefulWidget {
  final int id, categoryId;
  final String name, img, orderId;

  const SubCategoryDetails(
      {Key key, this.id, this.name, this.img, this.categoryId, this.orderId})
      : super(key: key);

  @override
  _SubCategoryDetailsState createState() => _SubCategoryDetailsState();
}

class _SubCategoryDetailsState extends State<SubCategoryDetails> {
  @override
  void initState() {
    getSubCategoryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(
                widget.name,
                style: TextStyle(fontSize: 18),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => Home()),
                      (route) => false);
                },
              ),
              actions: [
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(widget.img), fit: BoxFit.cover)),
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  padding: const EdgeInsets.all(1),
                ),
              ],
            ),
            AppBarFoot(),
          ],
        ),
      ),
      bottomSheet: loading
          ? MyLoading()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .28,
              decoration: BoxDecoration(
                  color: MyColors.white,
                  border: Border.all(color: MyColors.grey, width: .5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tr("vat"), style: TextStyle(fontSize: 14)),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      addToCartModel.data == null
                                          ? subCategoryDetailsModel.data.tax
                                              .toString()
                                          : addToCartModel.data.tax.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.primary),
                                    ),
                                  ),
                                  Text(
                                    tr("rs"),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr("total"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        addToCartModel.data == null
                                            ? subCategoryDetailsModel.data.price
                                                .toString()
                                            : addToCartModel.data.price
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primary),
                                      ),
                                    ),
                                    Text(
                                      tr("rs"),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        tr("longText01"),
                        style: GoogleFonts.ibmPlexSans(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CustomButton(
                      height: 40,
                      title: tr("continue"),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (c) => Cart(
                        //       categoryId: widget.categoryId,
                        //     )));
                      },
                    ),
                  ],
                ),
              ),
            ),
      body: loading
          ? MyLoading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subCategoryDetailsModel.data.services.length,
                      itemBuilder: (c, i) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 75,
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            border: Border.all(width: .5, color: MyColors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (subCategoryDetailsModel
                                            .data.services[i].checked) {
                                          if (i == 0) {
                                            addToCart(
                                                counter: "down",
                                                serviceId:
                                                    subCategoryDetailsModel
                                                        .data.services[i].id
                                                        .toString(),
                                                unchecked: "0");
                                          } else {
                                            addToCart(
                                                counter: "down",
                                                serviceId:
                                                    subCategoryDetailsModel
                                                        .data.services[i].id
                                                        .toString(),
                                                unchecked: "1");
                                          }
                                        } else {
                                          addToCart(
                                              counter: "up",
                                              serviceId: subCategoryDetailsModel
                                                  .data.services[i].id
                                                  .toString(),
                                              unchecked: "0");
                                        }
                                        setState(() {
                                          subCategoryDetailsModel
                                                  .data.services[i].checked =
                                              !subCategoryDetailsModel
                                                  .data.services[i].checked;
                                        });
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            subCategoryDetailsModel
                                                    .data.services[i].checked
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: MyColors.primary,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                              subCategoryDetailsModel
                                                  .data.services[i].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    i == 0
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  subCategoryDetailsModel
                                                      .data.services[i].price
                                                      .toString()
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: MyColors.primary),
                                                ),
                                              ),
                                              Text(
                                                tr("rs"),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: MyColors.primary),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: Text(
                                    subCategoryDetailsModel
                                        .data.services[i].description,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: MyColors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                i != 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Text(
                                                    subCategoryDetailsModel
                                                        .data.services[i].price
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            MyColors.primary),
                                                  ),
                                                ),
                                                Text(
                                                  tr("rs"),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: MyColors.primary),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    addToCart(
                                                      serviceId:
                                                          subCategoryDetailsModel
                                                              .data
                                                              .services[i]
                                                              .id
                                                              .toString(),
                                                      counter: "up",
                                                      unchecked: "0",
                                                    );

                                                    setState(() {
                                                      subCategoryDetailsModel
                                                          .data
                                                          .services[i]
                                                          .count++;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.add_circle_outline,
                                                      size: 28,
                                                      color: MyColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  subCategoryDetailsModel
                                                      .data.services[i].count
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: MyColors.primary,
                                                      fontSize: 18),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      if (subCategoryDetailsModel
                                                              .data
                                                              .services[i]
                                                              .count >=
                                                          1) {
                                                        addToCart(
                                                          serviceId:
                                                              subCategoryDetailsModel
                                                                  .data
                                                                  .services[i]
                                                                  .id
                                                                  .toString(),
                                                          counter: "down",
                                                          unchecked: "0",
                                                        );
                                                      }
                                                      if (subCategoryDetailsModel
                                                              .data
                                                              .services[i]
                                                              .count ==
                                                          0) {
                                                        setState(() {
                                                          subCategoryDetailsModel
                                                              .data
                                                              .services[i]
                                                              .checked = false;
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        size: 28,
                                                        color: subCategoryDetailsModel
                                                                    .data
                                                                    .services[i]
                                                                    .count >=
                                                                1
                                                            ? MyColors.primary
                                                            : MyColors.grey,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      }),
                  Container(
                    height: MediaQuery.of(context).size.height * .28,
                  )
                ],
              ),
            ),
    );
  }

  String total, vat;
  AddToCartModel addToCartModel = AddToCartModel();

  Future addToCart({String serviceId, counter, unchecked}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/add-service-toOrder");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "category_id": widget.id.toString(),
          "service_id": serviceId,
          "counter": counter,
          "order_id": widget.orderId
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          getSubCategoryDetails();
          setState(() {
            addToCartModel = AddToCartModel.fromJson(responseData);
          });
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          print("----------------------------07");
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("----------------------------08");
      print("error $e" + " ==>> track $t");
    }
  }

  bool loading = true;
  SubCategoryDetailsModel subCategoryDetailsModel = SubCategoryDetailsModel();

  Future getSubCategoryDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/tech-order-services");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "category_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          subCategoryDetailsModel =
              SubCategoryDetailsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}
