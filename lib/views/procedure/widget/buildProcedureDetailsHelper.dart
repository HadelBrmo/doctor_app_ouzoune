import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/ImplantKit .dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../../../models/implant_model.dart';
import '../../kits/Kits_Controller/kits_controller.dart';

Widget buildHeaderCard(BuildContext context, bool isDarkMode, Color textColor, Procedure procedure) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: isDarkMode ? Colors.grey[800] : Colors.white,
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Procedure #${procedure.id ?? 'N/A'}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Chip(
                label: Text(
                  procedure.statusText ?? 'Unknown',
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                ),
                backgroundColor: procedure.statusColor ?? Colors.grey,
              ),
            ],
          ),
          Divider(color: Colors.grey[400], height: 20),
          buildDetailRow('Doctor', procedure.doctor?.userName ?? 'No doctor', textColor),
          buildDetailRow('Date', procedure.date != null
              ? DateFormat('dd-MM-yyyy').format(procedure.date!)
              : 'N/A', textColor),
          buildDetailRow('Time', procedure.date != null
              ? DateFormat('HH:mm').format(procedure.date!)
              : 'N/A', textColor),
          buildDetailRow('Assistants', '${procedure.numberOfAssistants ?? 0}', textColor),
          buildDetailRow('Clinic', procedure.doctor?.clinic?.name ?? 'No clinic', textColor),
        ],
      ),
    ),
  );
}

Widget buildDetailRow(String label, String value, Color textColor) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      ),
    ),
  );
}

Widget buildAssistantsList(Procedure procedure, bool isDarkMode) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: procedure.assistants!.map((assistant) => ListTile(
          leading: ClipOval(

            child: (assistant.profileImagePath != null && assistant.profileImagePath!.isNotEmpty)?
            Image.network(
              assistant.profileImagePath!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ):
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          title: Text(
            assistant.userName ?? 'Unknown',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          subtitle: Text(
            assistant.phoneNumber ?? 'No phone',
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
          ),
        )).toList(),
      ),
    ),
  );
}

Widget buildToolsList(List<AdditionalTool> tools, bool isDarkMode) {
  if (tools.isEmpty) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'No tools available',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    );
  }

  return Card(
      elevation: 2,
      margin: EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          width: 2,
        ),
      ),
    child: Column(
      children: tools.map((tool) => ListTile(
        leading: Icon(Icons.build, color: AppColors.primaryGreen),
        title: Text(tool.name ?? 'Unnamed Tool',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: Text('Qty: ${tool.quantity}',
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

      )).toList(),
    ),
  );
}

Widget buildSurgicalKitCard(Kit kit, BuildContext context, bool isDarkMode) {
  debugPrint('--- Kit Debug Info ---');
  debugPrint('ID: ${kit.id}, Name: ${kit.name}');
  debugPrint('Is Main Kit: ${kit.isMainKit}');
  debugPrint('Tools Count: ${kit.tools.length}');
  debugPrint('Building Surgical Kit: ${kit.name}');
  debugPrint('Tools count in build: ${kit.tools.length}');
  if (kit.tools.isNotEmpty) {
    debugPrint('First tool: ${kit.tools.first.name}');
  }
  debugPrint('----------------------');
  return Card(
    elevation: 2,
    margin: EdgeInsets.only(top: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: ExpansionTile(
      iconColor: Colors.green,
      collapsedIconColor: Colors.green,
      leading: Icon(Icons.medical_services, color: Colors.green),
      title: Text(
        kit.name,
        style: TextStyle(
          fontFamily: 'Montserrat',

          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        'Surgical Kit',
        style: TextStyle(
            color: Colors.green,
            fontFamily: 'Montserrat'
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kit.tools.isNotEmpty) ...[
                buildSectionTitle('Tools (${kit.tools.length})'),
                ...kit.tools.map((tool) => buildToolItem(tool, isDarkMode)),
                SizedBox(height: 10),
              ],
              if (kit.implants.isNotEmpty) ...[
                buildSectionTitle('Implants (${kit.implants.length})'),
                ...kit.implants.map((implant) => buildImplantItem(implant, isDarkMode)),
                SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildToolDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ],
    ),
  );
}

Widget buildKitCard(Kit kit, BuildContext context, bool isDarkMode) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.only(top: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: ExpansionTile(
      iconColor: AppColors.lightGreen,
      collapsedIconColor: AppColors.lightGreen,
      leading: Icon(Icons.construction, color: AppColors.lightGreen),
      title: Text(
        "implant kits",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kit.implants.isNotEmpty) ...[
                buildSectionTitle('Implants (${kit.implants.length})'),
                ...kit.implants.map((implant) => buildImplantItem(implant, isDarkMode)),
                SizedBox(height: 10),
              ],
              if (kit.tools.isNotEmpty) ...[
                buildSectionTitle('tools with implant (${kit.tools.length})'),
                ...kit.tools.map((tool) => buildToolItem(tool, isDarkMode)),
                SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildImplantItem(Implant implant, bool isDarkMode) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 3,
      ),
    ),
    elevation: 1,
    margin: EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(Icons.medication, color: AppColors.primaryGreen),
      title: Text(
        implant.brand ?? 'Unknown brand',
        style: TextStyle(fontFamily: 'Montserrat',),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(implant.description ?? 'No description',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)),
          SizedBox(height: 4),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Qty: ${implant.quantity ?? 0}',
            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildToolItem(AdditionalTool tool,isDarkMode) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    elevation: 1,
    margin: EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(Icons.build, color: AppColors.primaryGreen),
      title: Text(
        tool.name!,
        style: TextStyle(fontFamily: 'Montserrat',),
      ),
      trailing:Text(
        'Qty: ${tool.quantity}',
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey
        ),
      ),


    ),
  );
}

Widget buildImplantKitCard(ImplantKit implantKit, BuildContext context, bool isDarkMode) {
  final KitsController _controller = Get.put(KitsController());

  return Card(
    elevation: 2,
    margin: EdgeInsets.only(top: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: ExpansionTile(
      iconColor: AppColors.lightGreen,
      collapsedIconColor: AppColors.lightGreen,
      leading: Icon(Icons.medical_services, color: AppColors.lightGreen),
      title: Text(
        _controller.getImplantNameByKitId(implantKit.implant.kitId ?? 0),
        style: TextStyle(
          fontFamily: 'Montserrat',

          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        "${implantKit.implant.description}",
        style: TextStyle(
            color: AppColors.lightGreen,
            fontFamily: 'Montserrat'
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildSectionTitle('Implant Details'),
              // ListTile(
              //   contentPadding: EdgeInsets.zero,
              //   leading: Icon(Icons.medication, color: AppColors.primaryGreen),
              //   title: Text(
              //     implantKit.implant.brand ?? 'No Brand',
              //     style: TextStyle(
              //       fontFamily: 'Montserrat',
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       if (implantKit.implant.description != null &&
              //           implantKit.implant.description!.isNotEmpty)
              //         Text(
              //           implantKit.implant.description!,
              //           style: TextStyle(
              //             fontFamily: 'Montserrat',
              //             color: Colors.grey[600],
              //           ),
              //         ),
              //       SizedBox(height: 4),
              //       Row(
              //         children: [
              //           Text(
              //             'Size: ${implantKit.implant.width} x ${implantKit.implant.height}',
              //             style: TextStyle(
              //               fontFamily: 'Montserrat',
              //               fontSize: 12,
              //             ),
              //           ),
              //           SizedBox(width: 16),
              //           Text(
              //             'Qty: ${implantKit.implant.quantity}',
              //             style: TextStyle(
              //               fontFamily: 'Montserrat',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              //   trailing: implantKit.implant.imagePath != null &&
              //       implantKit.implant.imagePath!.isNotEmpty
              //       ? Image.network(
              //     implantKit.implant.imagePath!,
              //     width: 50,
              //     height: 50,
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Icon(
              //           Icons.image_not_supported,
              //           size: 30,
              //           color: Colors.grey
              //       );
              //     },
              //   )
              //       : null,
              // ),
              SizedBox(height: 10),
              if (implantKit.toolsWithImplant.isNotEmpty) ...[
                buildSectionTitle('Associated Tools (${implantKit.toolsWithImplant.length})'),
                ...implantKit.toolsWithImplant.map((tool) => buildToolItem(tool, isDarkMode)),
                SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}