import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class LabelTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String initialValue;
  final EdgeInsets margin;
  final bool isPassword;
  final TextInputType type;
  final Function(String value) validate;
  final Function() onSubmit;
  final Function(String) onChange;
  final TextInputAction action;
  final double minWidth;
  final double maxWidth;
  final int lines;

  LabelTextField({this.label,this.hint,this.controller,this.onChange,
    this.margin,this.isPassword=false,this.action,this.onSubmit,
    this.type=TextInputType.text,this.validate,this.minWidth,this.maxWidth, this.lines, this.initialValue});
  @override
  _LabelTextFieldState createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin??EdgeInsets.all(0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 45,
            maxHeight: MediaQuery.of(context).size.height*.8,
            minWidth: widget.minWidth??double.infinity,
            maxWidth: widget.maxWidth??double.infinity
        ),
        child: TextFormField(
          initialValue: widget.initialValue,
          maxLines: widget.lines??1,
          // minLines: widget.lines??1,
          controller: widget.controller,
          keyboardType: widget.type?? TextInputType.text,
          obscureText: widget.isPassword,
          onEditingComplete: widget.onSubmit,
          onChanged: widget.onChange,
          enableSuggestions: false,
          autocorrect: false,
          textInputAction: widget.action?? TextInputAction.done,
          style: GoogleFonts.almarai(fontSize: 16,color: Colors.black),
          validator: (value)=> widget.validate(value),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.grey.withOpacity(.8),width: 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: MyColors.accent,width: 1.5)
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.grey.withOpacity(.5),width: 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red,width: 2)
              ),
              errorStyle: GoogleFonts.almarai(fontSize: 12),
              labelText: "  ${widget.label??""}  ",
              hintText: "  ${widget.hint??""}  ",
              // enabled: true,
              // alignLabelWithHint: true,
            // isDense: true,
            // isCollapsed: true,

              labelStyle: GoogleFonts.almarai(fontSize: 14,color: MyColors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              filled: true,
              fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
