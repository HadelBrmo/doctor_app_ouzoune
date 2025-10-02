import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/constants/app_images.dart';
import '../views/procedure/procedure_controller/procedure_controller.dart';
import '../views/procedure/widget/showFilterDialog.dart';

class Getsearch extends StatelessWidget {
  const Getsearch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<ProcedureController>();

    return Row(
      children: [
        Expanded(
          child: Container(
            height: context.height * 0.06,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) {
                debounce(
                  controller.searchQuery,
                      (value) {
                    controller.searchQuery.value = value;
                  },
                  time: Duration(milliseconds: 500),
                );
              },
              cursorColor: AppColors.primaryGreen,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search by assistant name",
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(width: 10),
        // Container(
        //   height: context.height * 0.06,
        //   width: context.width * 0.12,
        //   decoration: BoxDecoration(
        //     color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: IconButton(
        //     onPressed: () {
        //       showFilterDialog(context);
        //     },
        //     icon: Icon(Icons.filter_list, color: Colors.grey),
        //   ),
        // ),
      ],
    );
  }
}