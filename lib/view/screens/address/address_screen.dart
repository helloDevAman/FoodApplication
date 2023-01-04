import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'my_address'.tr),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).cardColor),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, 0)),
      ),
      floatingActionButtonLocation: ResponsiveHelper.isDesktop(context) ? FloatingActionButtonLocation.centerFloat : null,
      body: _isLoggedIn ? GetBuilder<LocationController>(builder: (locationController) {
        return locationController.addressList != null ? locationController.addressList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await locationController.getAddressList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: ListView.builder(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: locationController.addressList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (dir) {
                      showDialog(context: context, builder: (context) => CustomLoader(), barrierDismissible: false);
                      locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                        Navigator.pop(context);
                        showCustomSnackBar(response.message, isError: !response.isSuccess);
                      });
                    },
                    child: AddressWidget(
                      address: locationController.addressList[index], fromAddress: true,
                      onTap: () {
                        Get.toNamed(RouteHelper.getMapRoute(
                          locationController.addressList[index], 'address',
                        ));
                      },
                      onEditPressed: () {
                        Get.toNamed(RouteHelper.getEditAddressRoute(locationController.addressList[index]));
                      },
                      onRemovePressed: () {
                        if(Get.isSnackbarOpen) {
                          Get.back();
                        }
                        Get.dialog(ConfirmationDialog(icon: Images.warning, description: 'are_you_sure_want_to_delete_address'.tr, onYesPressed: () {
                          Get.back();
                          Get.dialog(CustomLoader(), barrierDismissible: false);
                          locationController.deleteUserAddressByID(locationController.addressList[index].id, index).then((response) {
                            Get.back();
                            showCustomSnackBar(response.message, isError: !response.isSuccess);
                          });
                        }));
                      },
                    ),
                  );
                },
              ),
            )),
          )),
        ) : NoDataScreen(text: 'no_saved_address_found'.tr) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}
