import 'package:equatable/equatable.dart';
import 'package:flutter_starter/data/utils/dateconverter.dart';

class TicketType extends Equatable {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  double? price;
  int? availableTickets;
  String? description;

  int quantity = 0;

  TicketType({this.id, this.createdAt, this.updatedAt, this.title, this.price, this.availableTickets, this.description});

  TicketType.fromJson(Map<String, dynamic> json, {bool isUtc = true, DateFormatSource? dateFormatSource}) {
    id = json['id'];
    createdAt = DateConverter.fromJson(jsonDateString: json['created_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    updatedAt = DateConverter.fromJson(jsonDateString: json['updated_at'], isUtc: isUtc,dateFormatSource: dateFormatSource);
    title = json['title'];
    price = json['price'];
    availableTickets = json['available_tickets'];
    description = json['description'];
  }

  Map<String, dynamic> toJson({bool isUtc = true, DateFormatSource? dateFormatSource}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = DateConverter.toJson(date: this.createdAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['updated_at'] = DateConverter.toJson(date: this.updatedAt, isUtc: isUtc,dateFormatSource: dateFormatSource);
    data['title'] = this.title;
    data['price'] = this.price;
    data['available_tickets'] = this.availableTickets;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, createdAt, updatedAt, title, price, availableTickets, description];
}
