import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:nava_tech/helpers/customs/single_choice_item.dart';
import 'package:nava_tech/helpers/models/OrderDetailsModel.dart';
import 'package:nava_tech/layouts/Home/orders/subcategories_screen.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import 'RejectReason.dart';
import 'SuccessfulOrder.dart';
import 'orders_notices_screen.dart';

enum order { accepted, arrived, started, done }

class OrderDetails extends StatefulWidget {
  final int id;
  final String clientImage;

  const OrderDetails({Key key, this.id, this.clientImage}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool loading = true;
  String status;

  @override
  void initState() {
    getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    print('rebuilding...');
    print('the incoming status inside build is is :$status');

    String blueButtonTitle;
    String redButtonTitle;

    if (status == 'created') {
      blueButtonTitle = 'قبول الطلب';
      redButtonTitle = 'رفض الطلب';
    } else if (status == 'accepted') {
      blueButtonTitle = 'تم الوصول للموقع';
      redButtonTitle = 'الغاء الطلب';
    } else if (status == 'arrived') {
      blueButtonTitle = 'بدء العمل';
      redButtonTitle = 'الغاء الطلب';
    } else if (status == 'in-progress') {
      blueButtonTitle = 'اضافة فاتورة';
      redButtonTitle = 'انهاء الطلب';
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("orderDetails"),
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
      bottomSheet: loading
          ? SizedBox()
          : orderDetailsModel.data.orderStatus != 'finished'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      textSize: 16,
                      width: MediaQuery.of(context).size.width * .38,
                      borderRadius: BorderRadius.circular(4),
                      title: blueButtonTitle,
                      onTap: () async {
                        if (orderDetailsModel.data.orderStatus == 'created') {
                          await orderRequests(order.accepted);
                        } else if (orderDetailsModel.data.orderStatus ==
                            'accepted') {
                          await orderRequests(order.arrived);
                        } else if (orderDetailsModel.data.orderStatus ==
                            'arrived') {
                          await orderRequests(order.started);
                        } else if (orderDetailsModel.data.orderStatus ==
                            'in-progress') {
                          buildShowModalBottomSheet(context, screenHeight);
                        }
                        await getOrderDetails();
                      },
                    ),
                    CustomButton(
                      width: MediaQuery.of(context).size.width * .38,
                      textSize: 16,
                      borderRadius: BorderRadius.circular(4),
                      color: orderDetailsModel.data.orderStatus != 'in-progress'
                          ? MyColors.red
                          : Colors.green,
                      title: redButtonTitle,
                      onTap: () {
                        if (orderDetailsModel.data.orderStatus ==
                            'in-progress') {
                          orderRequests(order.done);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => RejectReason(
                                id: widget.id,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              : SizedBox(),
      body: loading
          ? MyLoading()
          : ListView(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("orderNum"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      orderDetailsModel.data.orderNum,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Divider(
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("status"),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      orderDetailsModel.data.status,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen),
                    ),
                  ],
                ),
                Divider(
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.03,
                ),
                Text(
                  tr("exDate"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Container(
                  height: screenHeight * 0.18,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.clientImage,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        orderDetailsModel.data.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.date_range_outlined,
                          color: MyColors.primary,
                        ),
                      ),
                      Text(
                        orderDetailsModel.data.date,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderDetailsModel.data.categoryTitle,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Image(
                      image: ExactAssetImage(Res.electric),
                      height: 30,
                    )
                  ],
                ),
                Divider(
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("address"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      InkWell(
                        onTap: () {
                          MapsLauncher.launchCoordinates(
                              orderDetailsModel.data.lat,
                              orderDetailsModel.data.lng);
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            tr("showMap"),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .2,
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
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.02,
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
                              fontSize: 16, fontWeight: FontWeight.w600),
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
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    tr("serviceDetails"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 175.0 * orderDetailsModel.data.services.length,
                  child: ListView.builder(
                      itemCount: orderDetailsModel.data.services.length,
                      physics: NeverScrollableScrollPhysics(),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    tr("notes"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,

                  // height: 80,

                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  margin: EdgeInsets.only(bottom: 15),
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
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.05,
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
                  thickness: .7,
                  color: Colors.blueGrey.shade200,
                  height: screenHeight * 0.04,
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
                  height: screenHeight * 0.12,
                ),
              ],
            ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context, double screenHeight) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        builder: (context) {
          List<bool> selections = List<bool>.filled(2, false, growable: false);
          return StatefulBuilder(
            builder: (context, setStateBuilder) {
              List<bool> singleSelection(bool selection, int index) {
                if (selections.contains(true)) {
                  int i = selections.indexOf(true);
                  selections[i] = false;
                  selections[index] = true;
                } else {
                  selections[index] = selection;
                }
                setStateBuilder(() {});
                print(selections);
                return selections;
              }

              return Container(
                height: screenHeight * 0.30,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.black38,
                      height: 3,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.receipt),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'نوع الفاتورة',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SingleChoiceItem(
                      function: singleSelection,
                      choicesList: selections,
                      index: 0,
                      title: "ملاحظات",
                    ),
                    SingleChoiceItem(
                      function: singleSelection,
                      choicesList: selections,
                      index: 1,
                      title: "خدمات",
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selections[0] == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderNoticesScreen(
                                    id: orderDetailsModel.data.id)));
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SubCategories(
                                  id: orderDetailsModel.data.id,
                                  orderId: orderDetailsModel.data.orderNum,
                                  img: orderDetailsModel.data.categoryImage,
                                  name: orderDetailsModel.data.categoryTitle,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('اضافة'),
                        style: ElevatedButton.styleFrom(
                            primary: MyColors.primary,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
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
        print(responseData);
        if (responseData["key"] == "success") {
          orderDetailsModel = OrderDetailsModel.fromJson(responseData);
          status = orderDetailsModel.data.orderStatus;
          _add();
          setState(() {
            loading = false;
          });
          print('the status inside function is : $status');
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future orderRequests(order status) async {
    String endPoint;

    switch (status) {
      case order.accepted:
        {
          endPoint = "api/accept-order";
        }
        break;
      case order.arrived:
        {
          endPoint = "api/arrive-to-order";
        }
        break;
      case order.started:
        {
          endPoint = "api/start-in-order";
        }
        break;
      case order.done:
        {
          endPoint = "api/finish-order";
        }
        break;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, endPoint);
    print(url);
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
        if (orderDetailsModel.data.orderStatus == 'in-progress' ||
            orderDetailsModel.data.orderStatus == 'created') {
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

  //the following code about initializing markers of map preview

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(orderDetailsModel.data.lat, orderDetailsModel.data.lng),
      // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

/*--------------------------*/

}
