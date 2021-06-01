import 'package:equatable/equatable.dart';
import 'package:flutter_starter/config/constant.dart';

class UniversitiesDto extends Equatable {
  String? name;
  int page;
  int pageSize;

  UniversitiesDto({
    this.name,
    this.page = 1,
    this.pageSize = Constant.LIST_PAGE_SIZE,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name, page, pageSize];
}
