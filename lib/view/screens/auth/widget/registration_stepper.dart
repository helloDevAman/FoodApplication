import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
class RegistrationStepper extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;
  final bool onGoing;
  final bool processing;
  const RegistrationStepper({Key key, @required this.isActive, @required this.haveLeftBar, @required this.haveRightBar,
    @required this.title, @required this.rightActive, this.onGoing = false, this.processing = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _color = onGoing ? Theme.of(context).primaryColor : isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    Color _right = onGoing ? Theme.of(context).disabledColor : rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    return Expanded(
      child: Column(children: [

        Row(children: [
          Expanded(child: haveLeftBar ? Divider(color: _color, thickness: 2) : SizedBox()),
          Icon( onGoing ? Icons.adjust : processing ? Icons.adjust : rightActive ? Icons.check_circle : Icons.circle_outlined, color: _color, size: 40),
          Expanded(child: haveRightBar ? Divider(color: _right, thickness: 2) : SizedBox()),
          ]),

          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          SizedBox(
            height: 30,
            child: Text(
              title, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
            ),
          ),
      ]),
    );
  }
}
