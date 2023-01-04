import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/data/model/response/package_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SubscriptionCard extends StatelessWidget {
  final int index;
  final Packages package;
  final AuthController authController;
  final Color color;
  const SubscriptionCard({Key key, @required this.index, @required this.package, @required this.authController, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(children: [

        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.RADIUS_LARGE), topRight: Radius.circular(Dimensions.RADIUS_LARGE)),
          child: Stack(
            children: [

              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                color: color.withOpacity(0.3),
                height: 140.0,
                ),
              ),

              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: color.withOpacity(0.2),
                  height: 160.0,
                ),
              ),

              // ClipPath(
              //   clipper: CurveClipper(),
              //   child: Container(
              //     alignment: Alignment.center,
              //     color: color.withOpacity(1), height: 120.0, width: double.infinity,
              //     child: Text('${package.packageName}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor)),
              //   ),
              // ),

              ClipPath(
                clipper: CurveClipper(),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: color.withOpacity(1), height: 120.0, width: double.infinity,
                      child: Text('${package.packageName}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor)),
                    ),
                  ],
                ),
              ),

            ]),
        ),

        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Text(
          PriceConverter.convertPrice(package.price),
          style: robotoBold.copyWith(fontSize: 35, color: color),
        ),

        Text('${'${package.validity} ' 'days'.tr}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Divider(color: color, indent: 70, endIndent: 70, thickness: 2),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          packageWidget(title: '${'max_order'.tr} (${package.maxOrder})'),

          packageWidget(title: '${'max_product'.tr} (${package.maxProduct})'),

          package.pos != 0 ? packageWidget(title: 'pos'.tr) : SizedBox(),

          package.mobileApp != 0 ? packageWidget(title: 'mobile_app'.tr) : SizedBox(),

          package.chat != 0 ? packageWidget(title: 'chat'.tr) : SizedBox(),

          package.review != 0 ? packageWidget(title: 'review'.tr) : SizedBox(),

          package.selfDelivery != 0 ? packageWidget(title: 'self_delivery'.tr) : SizedBox(),
        ]),

      ]),
    );
  }

  Widget packageWidget({ @required String title}){
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: ResponsiveHelper.isDesktop(Get.context) ? MediaQuery.of(Get.context).size.width * 0.05 : MediaQuery.of(Get.context).size.width * 0.15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Text(title, style: robotoMedium),
        ]),
      ),

      Divider(indent: 50, endIndent: 50, color: Theme.of(Get.context).dividerColor,thickness: 1,)
    ]);
  }
}



class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class HeaderStyle extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = Colors.white);

    Path bezierPath = Path()

      ..moveTo(0, size.height)

      ..lineTo(0, size.height * 0.8)

      ..quadraticBezierTo(

        size.width / 2,

        size.height * 0.6,

        size.width,

        size.height * 0.8,

      )

      ..lineTo(size.width, size.height);

    final bezierPaint = Paint()

      ..shader =

      LinearGradient(colors: [Colors.purple[400], Colors.teal[400]])

          .createShader(Offset(0, size.height * 0.8) & size);

    canvas.drawPath(bezierPath, bezierPaint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}
