import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/enums/invitation_request_status.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';

class InvitationRequest extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? sender;
  int? receiver;
  User? senderInfo;

  InvitationRequestStatus status = InvitationRequestStatus.NONE;

  InvitationRequest({this.id, this.createdAt, this.updatedAt, this.sender, this.receiver, this.senderInfo, this.status = InvitationRequestStatus.NONE});

  InvitationRequest.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    sender = json['sender'];
    receiver = json['receiver'];
    senderInfo = json['sender_info'] != null ? new User.fromJson(json['sender_info'], isUtc: isUtc,dateFormatSource: dateFormatSource) : null;
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    if (this.senderInfo != null) {
      data['sender_info'] = this.senderInfo!.toJson(isUtc: isUtc,dateFormatSource: dateFormatSource);
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        sender,
        receiver,
        senderInfo,
      ];
}
