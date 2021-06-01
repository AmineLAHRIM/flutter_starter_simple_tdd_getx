import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

enum SortByType {
  START_DATE,
  UPDATED_AT,
  CREATED_AT,
  DISTANCE,
  EVENT_TYPE,
}

class SortBy extends GetxController with EquatableMixin {
  SortByType? id;
  String? title;
  RxBool? isSelected = false.obs;

  SortBy({this.id, this.title, this.isSelected});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, isSelected];
}
