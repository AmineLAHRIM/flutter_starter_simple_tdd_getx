import 'package:flutter_starter/data/models/ticket_type.dart';

class OrderDto {
  late int event;
  List<TicketType>? ticketTypes;

  OrderDto({required this.event, this.ticketTypes});

  OrderDto.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    if (json['ticket_types'] != null) {
      ticketTypes = [];
      json['ticket_types'].forEach((v) {
        ticketTypes!.add(new TicketType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    if (this.ticketTypes != null) {
      data['ticket_types'] = this.ticketTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
