import 'dart:convert';

class NotificationMessageModel {
  final String? type;

  NotificationMessageModel({this.type});

  factory NotificationMessageModel.fromJson(Map<String, dynamic> json) {
    return NotificationMessageModel(type: json['type']?.toString());
  }
}
