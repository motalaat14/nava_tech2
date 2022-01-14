import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/layouts/Home/orders/OrderDetails.dart';

class OrderItem extends StatelessWidget {
  final int id;
  final String name, img, location, orderNum, status, date, time, from;

  const OrderItem({
    Key key,
    this.id,
    this.name,
    this.location,
    this.orderNum,
    this.status,
    this.date,
    this.time,
    this.from,
    this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => OrderDetails(
              id: id,
              clientImage: img,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width,
        height: 200,
        color: MyColors.white,
        child: Card(
          elevation: 5,
          color: MyColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.cover)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width * .67,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.offPrimary),
                          ),
                          Text(
                            from,
                            style:
                                TextStyle(fontSize: 12, color: MyColors.grey),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: MyColors.primary,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * .50,
                            child: Text(
                              location,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${tr("orderNum")} : ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          orderNum,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${tr("status")} : ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${tr("exDate")} : ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${tr("exTime")} : ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
