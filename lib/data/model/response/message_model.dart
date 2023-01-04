import 'dart:convert';

import 'package:efood_multivendor/data/model/response/conversation_model.dart';

class MessageModel {
  int totalSize;
  int limit;
  int offset;
  bool status;
  Conversation conversation;
  List<Message> messages;

  MessageModel({this.totalSize, this.limit, this.offset, this.status, this.conversation, this.messages});

  MessageModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    status = json['status'];
    conversation = json['conversation'] != null ? Conversation.fromJson(json['conversation']) : null;
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['status'] = this.status;
    if (this.conversation != null) {
      data['conversation'] = this.conversation.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int id;
  int conversationId;
  int senderId;
  String message;
  List<String> files;
  int isSeen;
  String createdAt;
  String updatedAt;

  Message(
      {this.id,
        this.conversationId,
        this.senderId,
        this.message,
        this.files,
        this.isSeen,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    message = json['message'];
    files = (json['file'] != 'null' && json['file'] != null) ? jsonDecode(json['file']).cast<String>() : [];
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['file'] = this.files;
    data['is_seen'] = this.isSeen;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
