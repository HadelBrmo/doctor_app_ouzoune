import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import 'buildDetailItem.dart';
import 'showQuantityDialog.dart';

Widget BuildSurgicalCard({
  required bool isAppear,
  required BuildContext context,
  required String imagePath,
  required String toolName,
  required String length,
  required String width,
  required String thickness,
  dynamic quantity,
  bool showQuantityDetail = false,
  required Function(int) onQuantitySelected,
  int? selectedQuantity,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    onTap: () {

    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: context.height * 0.01),
      color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.025),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tool Image
            Container(
              width: context.width * 0.2,
              height: context.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.width * 0.02),
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: context.width * 0.15,
                  height: context.width * 0.15,
                  color:  null,
                ),
              ),
            ),
            SizedBox(width: context.width * 0.04),
            // Tool Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontFamily: "Montserrat",
                    fontSize: context.width * 0.045,
                    isBold: true,
                    color: isDarkMode ? Colors.white : Colors.black,
                    text: toolName.tr, textAlign: TextAlign.start,
                  ),
                  SizedBox(height: context.height * 0.01),
                  Row(
                    children: [
                      BuildDetailItem(context, "Length", length),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Width", width),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Thickness", thickness),
                      if (showQuantityDetail) SizedBox(width: context.width * 0.02),
                    ],
                  )
                ],
              ),
            ),

            // Quantity Section
            if(isAppear)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(context.width * 0.02),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.03,
                      vertical: context.height * 0.005,
                    ),
                    child: Text(
                      selectedQuantity != null && selectedQuantity > 0
                          ? 'Qty: $selectedQuantity'
                          : 'Add',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: context.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.01),
                  GestureDetector(
                    onTap: () async {
                      final quantity = await ShowQuantityDialog(toolName);
                      if (quantity != null) {
                        onQuantitySelected(quantity);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen,
                      ),
                      padding: EdgeInsets.all(context.width * 0.02),
                      child: Icon(
                        selectedQuantity == null || selectedQuantity == 0
                            ? Icons.add
                            : Icons.edit,
                        color: Colors.white,
                        size: context.width * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}