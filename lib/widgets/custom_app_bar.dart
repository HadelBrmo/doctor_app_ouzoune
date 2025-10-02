import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, required this.ScaffoldKey,this.keyTool=220,required this.title,required this.text,
   });
   final GlobalKey<ScaffoldState>? ScaffoldKey;
     double keyTool;
     String title="";
      String text="";

  @override
  Size get preferredSize => Size.fromHeight(keyTool);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
              color: AppColors.lightGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(text,
                        style: TextStyle(
                          fontSize: context.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(title,
                        style: TextStyle(
                            fontSize: context.width * 0.09,
                            color: Colors.black
                        ),
                      )
                    ],
                  ),

                ],
              ),
            )

          ),
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 10,
          //   left: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       ScaffoldKey?.currentState?.openDrawer();
          //     },
          //     child: Icon(Icons.menu, color: Colors.black),
          //   ),
          // ),
        ],
      ),
    );
  }
}