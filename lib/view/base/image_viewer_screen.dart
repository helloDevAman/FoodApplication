import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen extends StatefulWidget {
  final Product product;
  ImageViewerScreen({@required this.product});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().setImageIndex(0, false);
    List<String> _imageList = [];
    _imageList.add(widget.product.image);

    return Scaffold(
      appBar: CustomAppBar(title: 'product_images'.tr),
      body: SafeArea(
        child: GetBuilder<ProductController>(builder: (productController) {
          return Column(children: [

            Expanded(child:  PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).canvasColor : Theme.of(context).cardColor),
              itemCount: _imageList.length,
              pageController: _pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage('${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${_imageList[index]}'),
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
                );
              },
              loadingBuilder: (context, event) => Center(child: Container(width: 20.0, height: 20.0, child: CircularProgressIndicator(
                value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ))),
              onPageChanged: (int index) => productController.setImageIndex(index, true)),
            ),

          ]);
        }),
      ),
    );
  }
}