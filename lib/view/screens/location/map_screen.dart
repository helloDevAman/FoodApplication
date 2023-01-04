import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:ui';

class MapScreen extends StatefulWidget {
  final AddressModel address;
  final bool fromRestaurant;
  MapScreen({@required this.address, this.fromRestaurant = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _latLng;
  Set<Marker> _markers = Set.of([]);
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'location'.tr),
      body: Center(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _latLng, zoom: 17),
              minMaxZoomPreference: MinMaxZoomPreference(0, 16),
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              markers:_markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
            Positioned(
              left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_LARGE,
              child: InkWell(
                onTap: () {
                  if(_mapController != null) {
                    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _latLng, zoom: 17)));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[300], spreadRadius: 3, blurRadius: 10)],
                  ),
                  child: widget.fromRestaurant ? Text(
                    widget.address.address, style: robotoMedium,
                  ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(children: [

                        Icon(
                          widget.address.addressType == 'home' ? Icons.home_outlined : widget.address.addressType == 'office'
                              ? Icons.work_outline : Icons.location_on,
                          size: 30, color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 10),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                            Text(widget.address.addressType.tr, style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                            )),

                            Text(widget.address.address, style: robotoMedium),

                            (widget.address.road != null && widget.address.road.isNotEmpty) ? Text('${'street_number'.tr}: ${widget.address.road}', style: robotoMedium) : SizedBox.shrink(),
                            (widget.address.house != null && widget.address.house.isNotEmpty) ? Text('${'house'.tr}: ${widget.address.house}', style: robotoMedium) : SizedBox.shrink(),
                            (widget.address.floor != null && widget.address.floor.isNotEmpty) ? Text('${'floor'.tr}: ${widget.address.floor}', style: robotoMedium) : SizedBox.shrink(),

                          ]),
                        ),
                      ]),

                      Text('- ${widget.address.contactPersonName}', style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),

                      Text('- ${widget.address.contactPersonNumber}', style: robotoRegular),

                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(
      widget.fromRestaurant ? Images.restaurant_marker : Images.location_marker, width: 120,
    );

    _markers = Set.of([]);
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

}
