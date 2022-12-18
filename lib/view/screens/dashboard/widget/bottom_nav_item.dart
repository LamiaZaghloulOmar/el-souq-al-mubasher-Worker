import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  final bool isimg;
  final String img;
  BottomNavItem({@required this.iconData, this.onTap, this.isSelected = false,
  this.img,this.isimg=false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon:isimg? Image.asset(img,color: isSelected ? Theme.of(context).primaryColor : Colors.grey, width: 25):
        Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 25),
        onPressed: onTap,
      ),
    );
  }
}
