import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locationPicker_controller.dart';

class LocationPicker extends StatelessWidget {
  final Function(LatLng, String) onLocationSelected;
  final bool useOSM;

  const LocationPicker({
    Key? key,
    required this.onLocationSelected,
    required this.useOSM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationPickerController());
    controller.useOSM = useOSM;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.locationName.value,
          style: Theme.of(context).textTheme.titleSmall,
        )),
        actions: [
          Obx(() => Visibility(
            visible: controller.selectedLocation.value != null,
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (controller.selectedLocation.value != null) {
                  onLocationSelected(
                    controller.selectedLocation.value!,
                    controller.locationName.value,
                  );
                  Get.back();
                }
              },
            ),
          )),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(33.5138, 36.2765),
          zoom: 12,
        ),
        onMapCreated: (ctrl) => controller.mapController = ctrl,
        onTap: controller.onMapTapped,
        markers: controller.selectedLocation.value == null
            ? {}
            : {
          Marker(
            markerId: MarkerId('selected'),
            position: controller.selectedLocation.value!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        },
      ),
    );
  }
}