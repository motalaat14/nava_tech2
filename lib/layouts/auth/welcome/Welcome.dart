// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nava_tech/helpers/constants/MyColors.dart';
// import 'package:nava_tech/helpers/customs/CustomButton.dart';
// import 'package:nava_tech/layouts/auth/login/Login.dart';
// import 'package:nava_tech/layouts/auth/register/Register.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../../../res.dart';
//
// class Welcome extends StatefulWidget {
//   @override
//   _WelcomeState createState() => _WelcomeState();
// }
//
// class _WelcomeState extends State<Welcome> {
//   PageController pgController;
//   ValueNotifier _notifier = new ValueNotifier<int>(0);
//   GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
//
//   PageController controller;
//
//   void movePage(int page) {
//     controller.animateToPage(page,
//         duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//   }
//
//   @override
//   void initState() {
//     pgController = PageController(initialPage: 0);
//     super.initState();
//   }
//
//   _setChangePage(val) {
//     setState(() {
//       _notifier.value = val;
//     });
//     print(_notifier.value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffold,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 40,left: 15,right: 15),
//               child: InkWell(
//                 onTap: (){
//                   print("skipppppppp");
//                   pgController.jumpToPage(2);
//                   setState(() {
//                     _notifier.value = 2;
//                   });
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(_notifier.value == 2 ? "" :"تخطي",style: TextStyle(color: MyColors.primary,fontSize: 16),),
//                     Icon(_notifier.value == 2 ? null:Icons.arrow_forward_ios,color: MyColors.primary,),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * .6,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: PageView(
//                 physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//                 onPageChanged: _setChangePage,
//                 controller: pgController,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Image.asset(
//                       Res.on1,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Image.asset(
//                       Res.on2,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Image.asset(
//                       Res.on3,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SmoothPageIndicator(
//               controller: pgController,
//               count: 3,
//               effect: ExpandingDotsEffect(
//                 activeDotColor: MyColors.primary,
//                 dotColor: MyColors.grey.withOpacity(.5),
//                 expansionFactor: 3,
//                 dotWidth: 10,
//                 dotHeight: 9,
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: Column(
//                 children: [
//                   Text(_notifier.value==0?"عنوان الترحيب ١":_notifier.value==1? "عنوان الترحيب ٢" :"عنوان الترحيب ٣",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: MyColors.offPrimary,
//                         fontWeight: FontWeight.w900,
//                       )),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(_notifier.value==0?"موضوع عنوان الترحيب ١ موضوع عنوان الترحيب ١":_notifier.value==1? "موضوع عنوان الترحيب ٢ موضوع عنوان الترحيب ٢" :"موضوع عنوان الترحيب ٣ موضوع عنوان الترحيب ٣",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: MyColors.grey,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//                 child: Container(
//                   child: CustomButton(
//                     borderRadius: BorderRadius.circular(30),
//                     title: _notifier.value == 2 ? "تسجيل" : "التالي",
//                     onTap: () {
//                       if (_notifier.value == 0) {
//                         pgController.jumpToPage(_notifier.value + 1);
//                         setState(() {
//                           _notifier.value = 1;
//                         });
//                       } else if (_notifier.value == 1) {
//                         pgController.jumpToPage(_notifier.value + 1);
//                         setState(() {
//                           _notifier.value = 2;
//                         });
//                       } else {
//                         print("3333333");
//                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=>Register()), (route) => false);
//                       }
//                     },
//                   ),
//                 )
//                 // : Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       InkWell(
//                 //           onTap: () {
//                 //             setState(() {
//                 //               _notifier.value = 2;
//                 //             });
//                 //           },
//                 //           child: Padding(
//                 //             padding:
//                 //                 const EdgeInsets.symmetric(horizontal: 8),
//                 //             child: Text("skip",
//                 //               style:TextStyle( color: MyColors.grey,)
//                 //             ),
//                 //           )),
//                 //       SmoothPageIndicator(
//                 //         controller: pgController,
//                 //         count: 3,
//                 //         effect: ExpandingDotsEffect(
//                 //           activeDotColor: MyColors.primary,
//                 //           dotColor: MyColors.grey.withOpacity(.5),
//                 //           expansionFactor: 3,
//                 //           dotWidth: 11,
//                 //           dotHeight: 7,
//                 //         ),
//                 //       ),
//                 //       InkWell(
//                 //         onTap: () {
//                 //           pgController.jumpToPage(_notifier.value + 1);
//                 //         },
//                 //         child: Container(
//                 //           width: 50,
//                 //           height: 50,
//                 //           decoration: BoxDecoration(
//                 //               color: MyColors.secondary,
//                 //               borderRadius: BorderRadius.circular(100)),
//                 //           child: Container(
//                 //             decoration: BoxDecoration(
//                 //                 color: MyColors.primary,
//                 //                 borderRadius: BorderRadius.circular(100)),
//                 //             margin: EdgeInsets.all(5),
//                 //             child: Icon(
//                 //               Icons.arrow_forward,
//                 //               color: MyColors.white,
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
