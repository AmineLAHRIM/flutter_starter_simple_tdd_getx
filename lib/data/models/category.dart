import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String? name;

  Category({this.name});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
