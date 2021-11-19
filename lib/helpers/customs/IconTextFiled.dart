import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class IconTextFiled extends StatelessWidget {
  TextEditingController controller;
  String label;
  EdgeInsets margin = EdgeInsets.all(0);
  EdgeInsets padding ;
  TextInputType type = TextInputType.text;
  Widget icon;
  Widget child;
  double childWidth;
  double width;
  double height;
  bool isPassword;
  Icon prefix;
  final Function(String value) validate;
  Color filledColor;
  Color textColor;
  final TextInputAction action;
  final Function(String value) submit;

  IconTextFiled(
      {this.label,
      this.controller,
      this.margin,
      this.padding,
      this.type,
      this.action,
      this.submit,
      this.icon,
      this.isPassword = false,
      this.prefix,
      this.filledColor,
      this.validate,
      this.child,
      this.childWidth,
      this.textColor,
      this.width,
      this.height,
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: height??75,
      width: width??MediaQuery.of(context).size.width,
      margin: margin,
      padding: padding,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        enabled: true,
        obscureText: isPassword,
        textInputAction: action ?? TextInputAction.done,
        onFieldSubmitted: submit,
        style: GoogleFonts.cairo(fontSize: 14, color: textColor),
        validator: (value) => validate(value),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: MyColors.primary, width: 1)),
            errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            // hintText: "$label",
            labelText: "$label",
            labelStyle: GoogleFonts.cairo(fontSize: 12, color: MyColors.grey),
            // hintStyle: GoogleFonts.cairo(fontSize: 14,color: MyColors.accent),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                  width: childWidth, child: child),
            ),
            filled: true,
            fillColor: filledColor ?? MyColors.white),
      ),
    );
  }
}
