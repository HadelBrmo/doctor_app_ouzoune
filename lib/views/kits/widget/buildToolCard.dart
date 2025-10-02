import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import 'buildDetailItem.dart';
import 'showQuantityDialog.dart';

class BuildToolCard extends StatelessWidget {
  final AdditionalTool tool;
  final int selectedQuantity;
  final Function(int) onQuantitySelected;

  const BuildToolCard({
    required this.tool,
    required this.selectedQuantity,
    required this.onQuantitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryGreen.withOpacity(0.1),
              ),
              child: (tool.imagePath != null && tool.imagePath!.isNotEmpty)
                  ? Image.network(
                tool.imagePath!,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.build,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name ?? 'Unnamed Tool',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),
                  Row(
                    children: [
                      BuildDetailItem(context, "Thickness", "${tool.thickness ?? 'N/A'}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Width", "${tool.width ?? 'N/A'}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Height", "${tool.height ?? 'N/A'}"),
                      SizedBox(width: context.width * 0.02),
                      BuildDetailItem(context, "Qty", "${tool.quantity ?? 0}", takeFirstDigit: true),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  selectedQuantity > 0 ? 'Qty: $selectedQuantity' : 'Add',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.height * 0.01),
                GestureDetector(
                  onTap: () async {

                    if ((tool.quantity ?? 0) <= 0) {
                      Get.snackbar(
                        "Out of Stock",
                        "This tool is currently out of stock",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: Duration(seconds: 3),
                      );
                      return;
                    }

                    final quantity = await ShowQuantityDialog(
                      tool.name ?? 'Tool',
                      maxQuantity: tool.quantity ?? 1,
                    );

                    if (quantity != null) {
                      if (quantity <= (tool.quantity ?? 0)) {
                        onQuantitySelected(quantity);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Quantity cannot exceed available stock (${tool.quantity})",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (tool.quantity ?? 0) <= 0
                          ? Colors.grey
                          : AppColors.primaryGreen,
                    ),
                    padding: EdgeInsets.all(context.width * 0.02),
                    child: Icon(
                      selectedQuantity > 0 ? Icons.edit : Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}