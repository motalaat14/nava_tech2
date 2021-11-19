import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';
import 'package:nava_tech/layouts/Home/orders/ConfirmedOrders.dart';
import 'package:nava_tech/layouts/Home/orders/FinishedOrders.dart';
import 'package:nava_tech/layouts/Home/orders/NewOrders.dart';
import 'package:nava_tech/layouts/Home/orders/SupportOrders.dart';
import 'package:nava_tech/layouts/more/contact_us/ContactUs.dart';
import 'package:nava_tech/res.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'drawer/MyDrawer.dart';

class Home extends StatefulWidget {
  final int index;

  const Home({Key key, this.index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  bool open=true;

  String name,phone,img;
  initUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
      phone = preferences.getString("phone");
      img = preferences.getString("image");
    });
  }

  @override
  void initState() {
    initUserData();
    super.initState();
    setState(() {
      tabs = [
        NewOrders(),
        ConfirmedOrders(),
        FinishedOrders(),
        SupportOrders(),
      ];
    });
    whichPage();
  }

  TabController tabController;
  int currentTabIndex = 0;
  List<Widget> tabs = [];
  whichPage() async {
    if (widget.index != null) {
      setState(() {
        currentTabIndex = widget.index;
      });
    } else {
      setState(() {
        currentTabIndex = 0;
      });
    }
  }
  void onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        _scaffold.currentState.openDrawer();
                      },
                      child: Container(
                        width: 50,height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: NetworkImage(img))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:4),
                            child: Row(
                              children: [
                                Text("${tr("welcome")} , ",style: TextStyle(fontSize: 16),),
                                Text(name.toString(),style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:4),
                            child: Text(tr("browseOrders"),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              elevation: 0,
              actions: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ContactUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(image: ExactAssetImage(Res.contactus),width: 26,),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr("available"),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  Switch(
                    trackColor: MaterialStateColor.resolveWith((states) => MyColors.accent),
                      value: open,
                      activeColor:  MyColors.green,
                      onChanged: (val){
                        setState(() {
                          open=val;
                        });
                      }
                  ),
                ],
              ),

            )
          ],
        ),
      ),

      drawer: MyDrawer(name: name,phone: phone,img: img),
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 1),
        height: MediaQuery.of(context).size.height * 0.088,
        color: MyColors.grey.withOpacity(.4),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 30, color: MyColors.primary),
          unselectedIconTheme: IconThemeData(size: 16, color: MyColors.accent),
          selectedLabelStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 13),
          selectedItemColor: MyColors.primary,
          unselectedItemColor: MyColors.accent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          currentIndex: currentTabIndex,
          onTap: onTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(image: ExactAssetImage(Res.neworders),width: currentTabIndex==0 ? 30:24,color: currentTabIndex==0?MyColors.primary:MyColors.accent.withOpacity(.7),),
              title: Text(tr("newOrders")),
            ),
            BottomNavigationBarItem(
              icon: Image(image: ExactAssetImage(Res.confirmorders),width: currentTabIndex==1 ? 30:24,color: currentTabIndex==1?MyColors.primary:MyColors.accent.withOpacity(.7),),
              title: Text(tr("confirmedOrders")),
            ),
            BottomNavigationBarItem(
              icon: Image(image: ExactAssetImage(Res.endorders),width: currentTabIndex==2 ? 30:24,color: currentTabIndex==2?MyColors.primary:MyColors.accent.withOpacity(.7),),
              title: Text(tr("finishedOrders")),
            ),
            BottomNavigationBarItem(
              icon: Image(image: ExactAssetImage(Res.maintenanceorderrs),width: currentTabIndex==3 ? 30:24,color: currentTabIndex==3?MyColors.primary:MyColors.accent.withOpacity(.7),),
              title: Text(tr("supportOrders")),
            ),
          ],
        ),
      ),
      body: tabs.elementAt(currentTabIndex),
      resizeToAvoidBottomInset: true,
    );
  }
}
























// int _selectedIndex = 0;
//
// List<Widget> tabItems = [
//   NewOrders(),
//   ConfirmedOrders(),
//   FinishedOrders(),
//   SupportOrders(),
// ];

//
// bottomNavigationBar: TitledBottomNavigationBar(
// currentIndex: _selectedIndex,
// onTap: (index)=> setState(() {_selectedIndex = index;}),
// activeColor: MyColors.primary,
// inactiveColor: MyColors.accent,
// indicatorColor: MyColors.primary,
// inactiveStripColor: MyColors.grey.withOpacity(.1),
// items: [
// TitledNavigationBarItem(title: Text('New'), icon: Icons.home),
// TitledNavigationBarItem(title: Text('Confirmed'), icon: Icons.search),
// TitledNavigationBarItem(title: Text('Finished'), icon: Icons.card_travel),
// TitledNavigationBarItem(title: Text('Support'), icon: Icons.shopping_cart),
// ]
// ),
//
//
// body: tabItems[_selectedIndex],
