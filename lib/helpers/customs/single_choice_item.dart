import 'package:flutter/material.dart';
import 'package:nava_tech/helpers/constants/MyColors.dart';

class SingleChoiceItem extends StatefulWidget {
  final String title;
  final int index;
  final Function function;
  final List<bool> choicesList;

  SingleChoiceItem({
    this.title,
    this.index,
    this.function,
    this.choicesList,
  });

  @override
  _SingleChoiceItemState createState() => _SingleChoiceItemState();
}

class _SingleChoiceItemState extends State<SingleChoiceItem> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          selected = !selected;
          widget.function(selected, widget.index);
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey.shade400),
            ),
            widget.choicesList[widget.index] == true
                ? Icon(
                    Icons.check_circle_sharp,
                    size: 30.0,
                    color: MyColors.primary,
                  )
                : Icon(
                    Icons.circle_outlined,
                    size: 30.0,
                    color: MyColors.primary,
                  ),
          ],
        ),
      ),
    );
  }
}
