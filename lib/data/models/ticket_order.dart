import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/models/enums/order_status.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/ticket_type.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';
import 'package:flutter_starter/data/utils/order_status_converter.dart';

class TicketOrder extends Equatable {
  int? id;
  String? orderNumber;
  List<Line>? lines;
  Event? eventInfo;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? refundedAt;
  int? event;
  int? user;
  int? payment;

  double totalPrice = 0;
  OrderStatus? orderStatus;
  String? totalDescription;

  TicketOrder({this.id, this.lines, this.eventInfo, this.createdAt, this.updatedAt, this.refundedAt, this.event, this.user, this.payment});

  TicketOrder.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    orderNumber = json['order_number'];
    if (json['lines'] != null) {
      lines = [];
      json['lines'].forEach((v) {
        lines!.add(new Line.fromJson(v));
      });
    }
    eventInfo = json['event_info'] != null ? new Event.fromJson(json['event_info']) : null;
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    refundedAt = DateConverter.fromJson(jsonDateString: json['refunded_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    orderStatus = OrderStatusConverter.fromJson(orderStatus: json['order_status']);
    event = json['event'];
    user = json['user'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;

    if (this.lines != null) {
      data['lines'] = this.lines!.map((v) => v.toJson()).toList();
    }
    if (this.eventInfo != null) {
      data['event_info'] = this.eventInfo!.toJson();
    }
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['refunded_at'] = DateConverter.toJson(date: this.refundedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['order_status'] = OrderStatusConverter.toJson(orderStatus: orderStatus);
    data['event'] = this.event;
    data['user'] = this.user;
    data['payment'] = this.payment;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        orderNumber,
        lines,
        eventInfo,
        createdAt,
        updatedAt,
        refundedAt,
        event,
        user,
        payment,
        totalPrice,
        orderStatus,
        totalDescription,
      ];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}

class Line extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? quantity;
  String? linePriceInclTax;
  String? linePriceExclTax;
  String? unitPriceInclTax;
  String? unitPriceExclTax;
  TicketType? ticketTypeInfo;
  int? ticketType;

  double totalPrice = 0;

  Line({this.id, this.createdAt, this.updatedAt, this.quantity, this.linePriceInclTax, this.linePriceExclTax, this.unitPriceInclTax, this.unitPriceExclTax, this.ticketTypeInfo, this.ticketType});

  Line.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    quantity = json['quantity'];
    linePriceInclTax = json['line_price_incl_tax'];
    linePriceExclTax = json['line_price_excl_tax'];
    unitPriceInclTax = json['unit_price_incl_tax'];
    unitPriceExclTax = json['unit_price_excl_tax'];
    ticketTypeInfo = json['ticket_type_info'] != null ? TicketType.fromJson(json['ticket_type_info'], isUtc: isUtc,dateFormatSource: dateFormatSource) : null;
    ticketType = json['ticket_type'];
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['quantity'] = this.quantity;
    data['line_price_incl_tax'] = this.linePriceInclTax;
    data['line_price_excl_tax'] = this.linePriceExclTax;
    data['unit_price_incl_tax'] = this.unitPriceInclTax;
    data['unit_price_excl_tax'] = this.unitPriceExclTax;
    if (this.ticketTypeInfo != null) {
      data['ticket_type_info'] = this.ticketTypeInfo!.toJson(isUtc: isUtc,dateFormatSource: dateFormatSource);
    }
    data['ticket_type'] = this.ticketType;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        quantity,
        linePriceInclTax,
        linePriceExclTax,
        unitPriceInclTax,
        unitPriceExclTax,
        ticketTypeInfo,
      ];
}
