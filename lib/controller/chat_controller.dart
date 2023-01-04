import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/notification_body.dart';
import 'package:efood_multivendor/data/model/response/message_model.dart';
import 'package:efood_multivendor/data/model/response/conversation_model.dart';
import 'package:efood_multivendor/data/repository/chat_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/user_type.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController implements GetxService {
  final ChatRepo chatRepo;
  ChatController({@required this.chatRepo});

  List<bool> _showDate;
  bool _isSendButtonActive = false;
  bool _isSeen = false;
  bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  List<Message>  _deliveryManMessage = [];
  List<Message>  _adminManMessage = [];
  List <XFile>_chatImage = [];
  List <Uint8List>_chatRawImage = [];
  MessageModel  _messageModel;
  ConversationsModel _conversationModel;
  ConversationsModel _searchConversationModel;
  bool _hasAdmin = true;

  bool get isLoading => _isLoading;
  List<bool> get showDate => _showDate;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  List<Message> get deliveryManMessage => _deliveryManMessage;
  List<Message> get adminManMessages => _adminManMessage;
  List<XFile> get chatImage => _chatImage;
  List<Uint8List> get chatRawImage => _chatRawImage;
  MessageModel get messageModel => _messageModel;
  ConversationsModel get conversationModel => _conversationModel;
  ConversationsModel get searchConversationModel => _searchConversationModel;
  bool get hasAdmin => _hasAdmin;

  Future<void> getConversationList(int offset) async {
    _hasAdmin = true;
    _searchConversationModel = null;
    Response response = await chatRepo.getConversationList(offset);
    if(response.statusCode == 200) {
      if(offset == 1) {
        _conversationModel = ConversationsModel.fromJson(response.body);
      }else {
        _conversationModel.totalSize = ConversationsModel.fromJson(response.body).totalSize;
        _conversationModel.offset = ConversationsModel.fromJson(response.body).offset;
        _conversationModel.conversations.addAll(ConversationsModel.fromJson(response.body).conversations);
      }
      int _index = -1;
      bool _sender;
      for(int index=0; index<_conversationModel.conversations.length; index++) {
        if(_conversationModel.conversations[index].receiverType == UserType.admin.name) {
          _index = index;
          _sender = false;
          break;
        }else if(_conversationModel.conversations[index].receiverType == UserType.admin.name) {
          _index = index;
          _sender = true;
          break;
        }
      }
      _hasAdmin = false;
      if(_index != -1) {
        _hasAdmin = true;
        if(_sender) {
          _conversationModel.conversations[_index].sender = User(
            id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
            phone: Get.find<SplashController>().configModel.phone, email: Get.find<SplashController>().configModel.email,
            image: Get.find<SplashController>().configModel.logo,
          );
        }else {
          _conversationModel.conversations[_index].receiver = User(
            id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
            phone: Get.find<SplashController>().configModel.phone, email: Get.find<SplashController>().configModel.email,
            image: Get.find<SplashController>().configModel.logo,
          );
        }
      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> searchConversation(String name) async {
    _searchConversationModel = ConversationsModel();
    update();
    Response response = await chatRepo.searchConversationList(name);
    if(response.statusCode == 200) {
      _searchConversationModel = ConversationsModel.fromJson(response.body);
      int _index = -1;
      bool _sender;
      for(int index=0; index<_searchConversationModel.conversations.length; index++) {
        if(_searchConversationModel.conversations[index].receiverType == UserType.admin.name) {
          _index = index;
          _sender = false;
          break;
        }else if(_searchConversationModel.conversations[index].receiverType == UserType.admin.name) {
          _index = index;
          _sender = true;
          break;
        }
      }
      if(_index != -1) {
        if(_sender) {
          _searchConversationModel.conversations[_index].sender = User(
            id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
            phone: Get.find<SplashController>().configModel.phone, email: Get.find<SplashController>().configModel.email,
            image: Get.find<SplashController>().configModel.logo,
          );
        }else {
          _searchConversationModel.conversations[_index].receiver = User(
            id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
            phone: Get.find<SplashController>().configModel.phone, email: Get.find<SplashController>().configModel.email,
            image: Get.find<SplashController>().configModel.logo,
          );
        }
      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeSearchMode() {
    _searchConversationModel = null;
    update();
  }

  Future<void> getMessages(int offset, NotificationBody notificationBody, User user, int conversationID, {bool firstLoad = false}) async {
    Response _response;
    if(firstLoad) {
      _messageModel = null;
      _isSendButtonActive = false;
      _isLoading = false;
    }
    if(notificationBody == null || notificationBody.adminId != null) {
      _response = await chatRepo.getMessages(offset, 0, UserType.admin, null);
    } else if(notificationBody.restaurantId != null) {
      _response = await chatRepo.getMessages(offset, notificationBody.restaurantId, UserType.vendor, conversationID);
    } else if(notificationBody.deliverymanId != null) {
      _response = await chatRepo.getMessages(offset, notificationBody.deliverymanId, UserType.delivery_man, conversationID);
    }

    if (_response != null && _response.body['messages'] != {} && _response.statusCode == 200) {
      if (offset == 1) {

        /// Unread-read
        if(conversationID != null && _conversationModel != null) {
          int _index = -1;
          for(int index=0; index<_conversationModel.conversations.length; index++) {
            if(conversationID == _conversationModel.conversations[index].id) {
              _index = index;
              break;
            }
          }
          if(_index != -1) {
            _conversationModel.conversations[_index].unreadMessageCount = 0;
          }
        }

        if(Get.find<UserController>().userInfoModel == null) {
          await Get.find<UserController>().getUserInfo();
        }
        /// Manage Receiver
        _messageModel = MessageModel.fromJson(_response.body);
        if(_messageModel.conversation == null) {
          _messageModel.conversation = Conversation(sender: User(
            id: Get.find<UserController>().userInfoModel.id, image: Get.find<UserController>().userInfoModel.image,
            fName: Get.find<UserController>().userInfoModel.fName, lName: Get.find<UserController>().userInfoModel.lName,
          ), receiver: notificationBody.adminId != null ? User(
            id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
            image: Get.find<SplashController>().configModel.logo,
          ) : user);
        }
        _sortMessage(notificationBody.adminId);
      }else {
        _messageModel.totalSize = MessageModel.fromJson(_response.body).totalSize;
        _messageModel.offset = MessageModel.fromJson(_response.body).offset;
        _messageModel.messages.addAll(MessageModel.fromJson(_response.body).messages);
      }
    } else {
      ApiChecker.checkApi(_response);
    }
    update();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _chatImage = [];
      _chatRawImage = [];
    }else {
      List<XFile> _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_imageFiles != null) {
        for(XFile xFile in _imageFiles) {
          if(_chatImage.length >= 3) {
            showCustomSnackBar('can_not_add_more_than_3_image'.tr);
            break;
          }else {
            XFile _xFile = await compressImage(xFile);
            _chatImage.add(_xFile);
            _chatRawImage.add(await _xFile.readAsBytes());
          }
        }
        _isSendButtonActive = true;
      }
    }
    update();
  }

  void removeImage(int index, String messageText){
    _chatImage.removeAt(index);
    _chatRawImage.removeAt(index);
    if(_chatImage.isEmpty && messageText.isEmpty) {
      _isSendButtonActive = false;
    }
    update();
  }

  Future<Response> sendMessage({@required String message, @required NotificationBody notificationBody,
  @required int conversationID, @required int index}) async {
    Response _response;
    _isLoading = true;
    update();

    List<MultipartBody> _myImages = [];
    _chatImage.forEach((image) {
      _myImages.add(MultipartBody('image[]', image));
    });

    if(notificationBody == null || notificationBody.adminId != null) {
      _response = await chatRepo.sendMessage(message, _myImages, 0, UserType.admin, null);
    } else if(notificationBody.restaurantId != null) {
      _response = await chatRepo.sendMessage(message, _myImages, notificationBody.restaurantId, UserType.vendor, conversationID);
    } else if(notificationBody.deliverymanId != null) {
      _response = await chatRepo.sendMessage(message, _myImages, notificationBody.deliverymanId, UserType.delivery_man, conversationID);
    }
    if (_response.statusCode == 200) {
      _chatImage = [];
      _chatRawImage = [];
      _isSendButtonActive = false;
      _isLoading = false;
      _messageModel = MessageModel.fromJson(_response.body);
      if(index != null && _searchConversationModel != null) {
        _searchConversationModel.conversations[index].lastMessageTime = DateConverter.isoStringToLocalString(_messageModel.messages[0].createdAt);
      }else if(index != null && _conversationModel != null) {
        _conversationModel.conversations[index].lastMessageTime = DateConverter.isoStringToLocalString(_messageModel.messages[0].createdAt);
      }
      if(_conversationModel != null && !_hasAdmin && (_messageModel.conversation.senderType == UserType.admin.name || _messageModel.conversation.receiverType == UserType.admin.name)) {
        _conversationModel.conversations.add(_messageModel.conversation);
        _hasAdmin = true;
      }
      if(Get.find<UserController>().userInfoModel.userInfo == null) {
        Get.find<UserController>().updateUserWithNewData(_messageModel.conversation.sender);
      }
      _sortMessage(notificationBody.adminId);
      Future.delayed(Duration(seconds: 2),() {
        getMessages(1, notificationBody, null, conversationID);
      });
    }
    update();
    return _response;
  }

  void _sortMessage(int adminId) {
    if(_messageModel.conversation != null && (_messageModel.conversation.receiverType == UserType.user.name
        || _messageModel.conversation.receiverType == UserType.customer.name)) {
      User _receiver = _messageModel.conversation.receiver;
      _messageModel.conversation.receiver = _messageModel.conversation.sender;
      _messageModel.conversation.sender = _receiver;
    }
    if(adminId != null) {
      _messageModel.conversation.receiver = User(
        id: 0, fName: Get.find<SplashController>().configModel.businessName, lName: '',
        image: Get.find<SplashController>().configModel.logo,
      );
    }
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

  void reloadConversationWithNotification(int conversationID) {
    int _index = -1;
    Conversation _conversation;
    for(int index=0; index<_conversationModel.conversations.length; index++) {
      if(_conversationModel.conversations[index].id == conversationID) {
        _index = index;
        _conversation = _conversationModel.conversations[index];
        break;
      }
    }
    if(_index != -1) {
      _conversationModel.conversations.removeAt(_index);
    }
    _conversation.unreadMessageCount++;
    _conversationModel.conversations.insert(0, _conversation);
    update();
  }

  void reloadMessageWithNotification(Message message) {
    _messageModel.messages.insert(0, message);
    update();
  }

  Future<XFile> compressImage(XFile file) async {
    final ImageFile _input = ImageFile(filePath: file.path, rawBytes: await file.readAsBytes());
    final Configuration _config = Configuration(
      outputType: ImageOutputType.webpThenPng,
      useJpgPngNativeCompressor: false,
      quality: (_input.sizeInBytes/1048576) < 2 ? 50 : (_input.sizeInBytes/1048576) < 5
          ? 30 : (_input.sizeInBytes/1048576) < 10 ? 2 : 1,
    );
    final ImageFile _output = await compressor.compress(ImageFileConfiguration(input: _input, config: _config));
    if(kDebugMode) {
      print('Input size : ${_input.sizeInBytes / 1048576}');
      print('Output size : ${_output.sizeInBytes / 1048576}');
    }
    return XFile.fromData(_output.rawBytes);
  }

}