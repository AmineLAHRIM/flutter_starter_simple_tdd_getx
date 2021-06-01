import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

enum DateOrderByType {
  UPCOMING,
  RECENTLY_ADDED,
  OLDEST,
}

class DateOrderBy extends GetxController with EquatableMixin {
  DateOrderByType? id;
  String? title;
  RxBool? isSelected = false.obs;

  DateOrderBy({this.id, this.title, this.isSelected});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, isSelected];
}
