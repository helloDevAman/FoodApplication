import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/screens/home/widget/restaurant_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController _controller;
  List<MarkerData> _customMarkers = [];
  int _reload = 0;

  @override
  void initState() {
    super.initState();

    if(Get.find<RestaurantController>().restaurantModel == null) {
      Get.find<RestaurantController>().getRestaurantList(1, false);
    }
    Get.find<SplashController>().setNearestRestaurantIndex(-1, notify: false);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  Widget _customMarker(String path) {
    return Stack(
      children: [
        Image.asset(Images.location_marker, height: 40, width: 40),
        Positioned(top: 3, left: 0, right: 0, child: Center(
          child: ClipOval(child: CustomImage(image: path, placeholder: Images.restaurant_placeholder, height: 20, width: 20, fit: BoxFit.cover)),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'nearby_restaurants'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return restController.restaurantModel != null ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkers,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                    double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    double.parse(Get.find<LocationController>().getUserAddress().longitude),
                  )),
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  onTap: (position) => Get.find<SplashController>().setNearestRestaurantIndex(-1),
                  minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController controller) {

                  },
                ),

                GetBuilder<SplashController>(builder: (splashController) {
                  return splashController.nearestRestaurantIndex != -1 ? Positioned(
                    bottom: 0,
                    child: RestaurantDetailsSheet(callback: (int index) => _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                      double.parse(restController.restaurantModel.restaurants[index].latitude),
                      double.parse(restController.restaurantModel.restaurants[index].longitude),
                    ), zoom: 16)))),
                  ) : SizedBox();
                }),

              ]);
            }
            return Stack(children: [

              GoogleMap(
                initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                  double.parse(Get.find<LocationController>().getUserAddress().latitude),
                  double.parse(Get.find<LocationController>().getUserAddress().longitude),
                )),
                markers: markers,
                myLocationEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: true,
                onTap: (position) => Get.find<SplashController>().setNearestRestaurantIndex(-1),
                minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  if(restController.restaurantModel != null && restController.restaurantModel.restaurants.isNotEmpty) {
                    _setMarkers(restController.restaurantModel.restaurants);
                  }
                },
              ),

              GetBuilder<SplashController>(builder: (splashController) {
                return splashController.nearestRestaurantIndex != -1 ? Positioned(
                  bottom: 0,
                  child: RestaurantDetailsSheet(callback: (int index) => _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                    double.parse(restController.restaurantModel.restaurants[index].latitude),
                    double.parse(restController.restaurantModel.restaurants[index].longitude),
                  ), zoom: 16)))),
                ) : SizedBox();
              }),

            ]);
          },
        ) : Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _setMarkers(List<Restaurant> restaurants) async {
    List<LatLng> _latLngs = [];
    _customMarkers = [];
    _customMarkers.add(MarkerData(
      marker: Marker(markerId: MarkerId('id-0'), position: LatLng(
        double.parse(Get.find<LocationController>().getUserAddress().latitude),
        double.parse(Get.find<LocationController>().getUserAddress().longitude),
      )),
      child: Image.asset(Images.my_location_marker, height: 20, width: 20),
    ));
    int _index = 0;
    for(int index=0; index<restaurants.length; index++) {
      _index++;
      LatLng _latLng = LatLng(double.parse(restaurants[index].latitude), double.parse(restaurants[index].longitude));
      _latLngs.add(_latLng);
      _customMarkers.add(MarkerData(
        marker: Marker(markerId: MarkerId('id-$_index'), position: _latLng, onTap: () {
          Get.find<SplashController>().setNearestRestaurantIndex(index);
        }),
        child: _customMarker('${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${restaurants[index].logo}'),
      ));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(Duration(milliseconds: 500));
    if(_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(Duration(seconds: 3));
    if(_reload == 1) {
      setState(() {});
      _reload = 2;
    }
  }

}

