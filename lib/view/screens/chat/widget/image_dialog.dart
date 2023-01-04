import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  const ImageDialog({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                    image: imageUrl, fit: BoxFit.contain, height: MediaQuery.of(context).size.width - 130, width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            ]),
        ),
      ),
    );
  }
}