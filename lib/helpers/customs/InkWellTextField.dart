import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class InkWellTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final EdgeInsets margin;
  final TextInputType type;
  final Widget icon;
  final Function onTab;
  final Icon prefix;
  final Color borderColor;
  final Color fillColor;
  final Function(String value) validate;
  final double minWidth;
  final double maxWidth;
  final double borderRadius;

  InkWellTextField(
      {this.label,
      this.controller,
      this.margin,
      this.type,
      this.onTab,
      this.icon,
      this.prefix,
      this.borderColor,
      this.validate, this.minWidth, this.maxWidth, this.fillColor, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: 50,
            minWidth: minWidth??double.infinity,
            maxWidth: maxWidth??double.infinity
        ),
        child: InkWell(
          onTap: onTab,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              keyboardType: type ?? TextInputType.text,
              enabled: true,
              validator: (value)=> validate(value),
              style: GoogleFonts.almarai(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                fillColor: fillColor?? MyColors.secondary.withOpacity(.5),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: borderColor ?? MyColors.grey.withOpacity(.5), width: 1),
                    borderRadius: BorderRadius.circular(borderRadius??10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius??10),
                    borderSide: BorderSide(
                        color: MyColors.primary.withOpacity(.5), width: 1)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: borderColor ?? MyColors.grey.withOpacity(.5),
                        width: 1),
                    borderRadius: BorderRadius.circular(borderRadius??10)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius??10),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                suffixIcon: icon,
                prefixIcon: prefix,
                errorStyle: GoogleFonts.almarai(fontSize: 14),
                labelText: " $label ",
                labelStyle: GoogleFonts.almarai(fontSize: 16,color: MyColors.offPrimary),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                filled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
