import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class RichTextFiled extends StatelessWidget{

  final TextEditingController controller;
  final String label;
  final EdgeInsets margin;
  final TextInputType type;
  final int min,max;
  final double height;
  final Function(String value) validate;
  final Color fillColor;
  final Color labelColor;
  final bool readOnly;
  final bool pass;
  final TextInputAction action;
  final Function(String value) submit;
  final Widget icon;

  RichTextFiled({
    this.label,
    this.controller,
    this.margin=const EdgeInsets.all(0),
    this.type=TextInputType.text,this.max,this.min,
    this.height,this.validate,
    this.fillColor,
    this.readOnly=false,
    this.action,
    this.submit,
    this.icon, this.labelColor, this.pass
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: TextFormField(
        obscureText: pass==null?false:pass,
        controller: controller,
        keyboardType: type??TextInputType.multiline,
        textInputAction: action?? TextInputAction.done,
        onFieldSubmitted: submit,
        // minLines: min,
        // maxLines: max,
        readOnly: readOnly,
        style: GoogleFonts.almarai(fontSize:20,color: MyColors.primary),
        validator: (value)=> validate(value),

        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.grey.withOpacity(.5),width: 1),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: MyColors.primary,width: 1)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.grey.withOpacity(.5),width: 1),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red,width: 1)
            ),
            errorStyle: GoogleFonts.almarai(fontSize: 14),
            labelText: " $label ",
            alignLabelWithHint: true,
            labelStyle: GoogleFonts.almarai(fontSize: 15,color:labelColor ?? MyColors.grey),
            fillColor: fillColor?? MyColors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            filled: true,
            suffixIcon: icon

        ),
      ),
    );
  }


}