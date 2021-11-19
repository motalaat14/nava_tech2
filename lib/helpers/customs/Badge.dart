import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 3,
          top: 3,
          child: Container(
            padding: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color != null ? color : MyColors.accent,
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: MyColors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }
}
