import 'package:equatable/equatable.dart';

class EventType extends Equatable {
  int? id;
  String? name;

  EventType({this.id, this.name});

  EventType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name];
}
