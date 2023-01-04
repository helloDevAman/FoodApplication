import 'package:efood_multivendor/view/screens/auth/widget/registration_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class RegistrationStepperWidget extends StatelessWidget {
  final String status;
  const RegistrationStepperWidget({Key key, @required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _status = 0;
     if(status == 'business') {
      _status = 1;
    }else if(status == 'payment') {
      _status = 2;
    }else if(status == 'complete') {
      _status = 3;
    }
    return Container(
      child: Row(children: [
        RegistrationStepper(
          title: 'general_information'.tr, isActive: true, haveLeftBar: false, haveRightBar: true, rightActive: true, onGoing: _status == 0,
        ),
        RegistrationStepper(
          title: 'business_plan'.tr, isActive: _status > 1, haveLeftBar: true, haveRightBar: true, rightActive: _status > 1, onGoing: _status == 1, processing: _status != 3 && _status != 0,
        ),
        RegistrationStepper(
          title: 'complete'.tr, isActive: _status == 3, haveLeftBar: true, haveRightBar: false, rightActive: _status == 3,
        ),
      ]),
    );
  }
}
