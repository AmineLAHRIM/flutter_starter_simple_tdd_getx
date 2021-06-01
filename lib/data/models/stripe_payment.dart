import 'package:equatable/equatable.dart';

class StripePayment extends Equatable {
  int? eventId;
  List<LineItem>? lineItems;
  String? successUrl;
  String? cancelUrl;

  StripePayment({this.eventId, this.lineItems, this.successUrl, this.cancelUrl});

  StripePayment.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    if (json['line_items'] != null) {
      lineItems = [];
      json['line_items'].forEach((v) {
        lineItems!.add(new LineItem.fromJson(v));
      });
    }
    successUrl = json['success_url'];
    cancelUrl = json['cancel_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems!.map((v) => v.toJson()).toList();
    }
    data['success_url'] = this.successUrl;
    data['cancel_url'] = this.cancelUrl;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [eventId, lineItems, successUrl, cancelUrl];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}

class LineItem extends Equatable {
  int? ticketTypeId;
  int? quantity;

  //double price;
  String? currency;

  LineItem({this.ticketTypeId, this.quantity, this.currency});

  LineItem.fromJson(Map<String, dynamic> json) {
    ticketTypeId = json['ticket_type_id'];
    quantity = json['quantity'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_type_id'] = this.ticketTypeId;
    data['quantity'] = this.quantity;
    data['currency'] = this.currency;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [ticketTypeId, quantity, currency];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
