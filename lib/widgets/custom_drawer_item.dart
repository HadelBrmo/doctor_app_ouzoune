import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/draw_item_model.dart';
import '../core/constants/app_colors.dart';


class CustomDrawerItem extends StatelessWidget {
  const CustomDrawerItem({super.key, required this.item});
  final DrawItemModel  item ;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon,
      color: AppColors.primaryGreen,
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(item.text.tr,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
            )),
      ),
      onTap: () {
      print("Tapped on ${item.text}");
      item.function.call();
    }
    //item.function?.call();
    );
  }
}
