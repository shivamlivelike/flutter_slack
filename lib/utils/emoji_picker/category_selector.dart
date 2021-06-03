import 'package:flutter/material.dart';

import 'category_icon.dart';

class CategorySelector extends StatelessWidget {
  final bool selected;
  final CategoryIcon icon;
  final Function() onSelected;
  final double width;
  final double height;
  final int column;

  const CategorySelector(
      {Key? key,
      required this.selected,
      required this.icon,
      required this.onSelected,
      required this.width,
      required this.height,
      required this.column})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / column,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          backgroundColor: selected ? Colors.black12 : Colors.transparent,
        ),
        child: Center(
          child: Icon(
            icon.icon,
            size: 22.0,
            color: selected ? icon.selectedColor : icon.color,
          ),
        ),
        onPressed: () {
          onSelected();
        },
      ),
    );
  }
}
