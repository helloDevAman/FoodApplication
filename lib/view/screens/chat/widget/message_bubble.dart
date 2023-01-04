import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/conversation_model.dart';
import 'package:efood_multivendor/data/model/response/message_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/user_type.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/screens/chat/widget/image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final User user;
  final UserType userType;
  const MessageBubble({Key key, @required this.message, @required this.user, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrl = Get.find<SplashController>().configModel.baseUrls;
    bool _isReply = message.senderId != Get.find<UserController>().userInfoModel.userInfo.id;
    
    return (message != null && _isReply) ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('${user.fName} ${user.lName}' ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

          ClipRRect(
            child: CustomImage(
              fit: BoxFit.cover, width: 40, height: 40,
              image: '${userType == UserType.admin ? _baseUrl.businessLogoUrl : userType == UserType.vendor
                  ? _baseUrl.restaurantImageUrl : _baseUrl.deliveryManImageUrl}/${user.image}',
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          SizedBox(width: 10),

          Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

              if(message.message != null) Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                      topRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                      bottomLeft: Radius.circular(Dimensions.RADIUS_DEFAULT),
                    ),
                  ),
                  padding: EdgeInsets.all(message.message != null ? Dimensions.PADDING_SIZE_DEFAULT : 0),
                  child: Text(message.message ?? ''),
                ),
              ),
              SizedBox(height: 8.0),

              (message.files != null && message.files.isNotEmpty) ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: message.files.length,
                  itemBuilder: (BuildContext context, index) {
                    return  message.files.length > 0 ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => showDialog(context: context, builder: (context) {
                          return ImageDialog(imageUrl: '${_baseUrl.chatImageUrl}/${message.files[index]}');
                        }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          child: CustomImage(
                            height: 100, width: 100, fit: BoxFit.cover,
                            image: '${_baseUrl.chatImageUrl}/${message.files[index] ?? ''}',
                          ),
                        ),
                      ),
                    ) : SizedBox();

                  }) : SizedBox(),

            ]),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Text(
          DateConverter.localDateToIsoStringAMPM(DateTime.parse(message.createdAt)),
          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
        ),
      ]),
    ) : Container(
      padding: const EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: GetBuilder<UserController>(builder: (profileController) {

        return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

          Text(
            '${profileController.userInfoModel != null ? profileController.userInfoModel.fName ?? '' : ''} '
                '${profileController.userInfoModel != null ? profileController.userInfoModel.lName ?? '' : ''}',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [

            Flexible(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

                (message.message != null && message.message.isNotEmpty) ? Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.RADIUS_DEFAULT),
                        bottomRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                        bottomLeft: Radius.circular(Dimensions.RADIUS_DEFAULT),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(message.message != null ? Dimensions.PADDING_SIZE_DEFAULT : 0),
                      child: Text(message.message ?? ''),
                    ),
                  ),
                ) : SizedBox(),

                (message.files != null && message.files.isNotEmpty) ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: GridView.builder(
                      reverse: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: message.files.length,
                      itemBuilder: (BuildContext context, index){
                        return  message.files.length > 0 ?
                        InkWell(
                          onTap: () => showDialog(context: context, builder: (context) {
                            return ImageDialog(imageUrl: '${_baseUrl.chatImageUrl}/${message.files[index]}');
                          }),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL , right:  0,
                              top: (message.message != null && message.message.isNotEmpty) ? Dimensions.PADDING_SIZE_SMALL : 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              child: CustomImage(
                                height: 100, width: 100, fit: BoxFit.cover,
                                image: '${_baseUrl.chatImageUrl}/${message.files[index] ?? ''}',
                              ),
                            ),
                          ),
                        ) : SizedBox();
                      }),
                ) : SizedBox(),
              ]),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CustomImage(
                fit: BoxFit.cover, width: 40, height: 40,
                image: profileController.userInfoModel != null ? '${_baseUrl.customerImageUrl}/${profileController.userInfoModel.image}' : '',
              ),
            ),
          ]),

          Icon(
            message.isSeen == 1 ? Icons.done_all : Icons.check,
            size: 12,
            color: message.isSeen == 1 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Text(
            DateConverter.localDateToIsoStringAMPM(DateTime.parse(message.createdAt)),
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        ]);
      }),
    );
  }
}
