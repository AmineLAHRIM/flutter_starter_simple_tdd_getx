import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

enum EventTypeOrderByType {
  STANDARD,
  ONLINE,
}

class EventTypeOrderBy extends GetxController with EquatableMixin {
  EventTypeOrderByType? id;
  String? title;
  RxBool? isSelected = false.obs;

  EventTypeOrderBy({this.id, this.title, this.isSelected});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, isSelected];
}
