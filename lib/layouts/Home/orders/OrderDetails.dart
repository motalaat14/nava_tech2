import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nava_tech/helpers/constants/LoadingDialog.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/helpers/constants/base.dart';
import 'package:nava_tech/helpers/customs/AppBarFoot.dart';
import 'package:nava_tech/helpers/customs/CustomButton.dart';
import 'package:nava_tech/helpers/customs/Loading.dart';
import 'package:nava_tech/helpers/models/OrderDetailsModel.dart';
import 'package:nava_tech/layouts/Home/orders/RejectReason.dart';
import 'package:nava_tech/layouts/Home/orders/SuccessfulOrder.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class OrderDetails extends StatefulWidget {
  final int id;
  final bool isConfirmed;
  const OrderDetails({Key key, this.id, this.isConfirmed}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    getOrderDetails();
    super.initState();
  }

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
              title: Text(tr("orderDetails"),
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
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
      body: loading
          ? MyLoading()
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("orderNum"),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orderDetailsModel.data.orderNum,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("status"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orderDetailsModel.data.status,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primary),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("exDate"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orderDetailsModel.data.date,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primary),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderDetailsModel.data.categoryTitle,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Image(
                        image: ExactAssetImage(Res.electric),
                        height: 30,
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        orderDetailsModel.data.lat, orderDetailsModel.data.lng);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr("address"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tr("showMap"),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .25,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.offPrimary, width: 1)),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(orderDetailsModel.data.lat,
                          orderDetailsModel.data.lng),
                      zoom: 16,
                    ),
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          tr("address"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${tr("neighbor")} : ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            orderDetailsModel.data.region,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              "${tr("street")} : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              orderDetailsModel.data.street,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${tr("house")} : ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            orderDetailsModel.data.residence,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              "${tr("floor")} : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              orderDetailsModel.data.floor,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${tr("addedNotes")} : ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            orderDetailsModel.data.addressNotes,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tr("serviceDetails"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.offPrimary),
                  ),
                ),
                Container(
                  height: 140.0 * orderDetailsModel.data.services.length,
                  child: ListView.builder(
                      itemCount: orderDetailsModel.data.services.length,
                      itemBuilder: (c, i) {
                        return serviceItem(
                          index: i,
                          img: orderDetailsModel.data.services[i].image,
                          title: orderDetailsModel.data.services[i].title,
                          price: orderDetailsModel.data.services[i].total
                              .toString(),
                        );
                      }),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tr("notes"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.offPrimary),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    orderDetailsModel.data.notes == ""
                        ? tr("noNotes")
                        : orderDetailsModel.data.notes,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  height: 120,
                  child: Row(
                    children: [
                      orderDetailsModel.data.files.isNotEmpty
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    viewImg(
                                        img: orderDetailsModel
                                            .data.files[0].image);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 90,
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: MyColors.white,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                orderDetailsModel
                                                    .data.files[0].image))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    tr("viewImg"),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                )
                              ],
                            )
                          : Text(tr("noMediaNotes")),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("vat"),
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Text(
                            orderDetailsModel.data.tax.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            tr("rs"),
                            style:
                                TextStyle(fontSize: 14, color: MyColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("total"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            orderDetailsModel.data.total.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            tr("rs"),
                            style:
                                TextStyle(fontSize: 14, color: MyColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("payWay"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orderDetailsModel.data.payType,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: !widget.isConfirmed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * .45,
                        borderRadius: BorderRadius.circular(10),
                        title: tr("acceptOrder"),
                        onTap: () {
                          acceptOrder();
                        },
                      ),
                      CustomButton(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * .45,
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.red,
                        title: tr("rejectOrder"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => RejectReason(
                                    id: widget.id,
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget followItem({String title, bool done, String location}) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 25,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: location == "top"
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                    : location == "end"
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                        : BorderRadius.circular(0),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: done ? MyColors.primary : MyColors.accent,
                    size: 45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget serviceItem({int index, String img, title, price}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: MediaQuery.of(context).size.width,
      // height: 150,
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height:
                orderDetailsModel.data.services[index].services.length * 18.0,
            child: ListView.builder(
              itemCount: orderDetailsModel.data.services[index].services.length,
              itemBuilder: (c, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    orderDetailsModel.data.services[index].services[i].title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primary),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("price"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tr("rs"),
                      style: TextStyle(fontSize: 14, color: MyColors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  viewImg({String img}) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Text(tr("viewImg"), style: GoogleFonts.almarai(fontSize: 15)),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * .4,
              child: PhotoView(
                imageProvider: NetworkImage(img),
              ),
            ),
            actions: [
              CustomButton(
                  title: tr("ok"),
                  onTap: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  bool loading = true;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel();
  Future getOrderDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/tech-order-details");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": "${widget.id}",
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          orderDetailsModel = OrderDetailsModel.fromJson(responseData);
          _add();
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  void _add() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(orderDetailsModel.data.lat, orderDetailsModel.data.lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future acceptOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/accept-order");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": "${widget.id}",
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
