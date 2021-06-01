import 'package:equatable/equatable.dart';

class RefundDto extends Equatable {
  String? orderNumber;
  String? reason;

  RefundDto({this.orderNumber, this.reason});

  RefundDto.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_number'] = this.orderNumber;
    data['reason'] = this.reason;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [orderNumber, reason];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
