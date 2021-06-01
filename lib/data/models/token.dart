import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Token extends Equatable {
  String? access;
  String? refresh;
  DateTime? accessExpiryAt;
  DateTime? refreshExpiryAt;

  Token({this.access, this.refresh, this.accessExpiryAt, this.refreshExpiryAt});

  var inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  Token.fromJson(Map<String, dynamic> json, [bool isUtc = true]) {
    access = json['access'];
    refresh = json['refresh'];
    accessExpiryAt = json['access_expiry_at'] != null ? (isUtc ? DateTime.parse(json['access_expiry_at']) : inputFormat.parseUtc(json['access_expiry_at']).toLocal()) : null;
    refreshExpiryAt = json['refresh_expiry_at'] != null ? (isUtc ? DateTime.parse(json['refresh_expiry_at']) : inputFormat.parseUtc(json['refresh_expiry_at']).toLocal()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access'] = this.access;
    data['refresh'] = this.refresh;
    data['access_expiry_at'] = this.accessExpiryAt!.toUtc().toIso8601String();
    data['refresh_expiry_at'] = this.refreshExpiryAt!.toUtc().toIso8601String();
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [access, refresh, accessExpiryAt, refreshExpiryAt];
}
