import 'package:equatable/equatable.dart';
import 'package:flutter_starter/config/constant.dart';

class UsersDto extends Equatable {
  int page;
  int pageSize;
  bool isFollowed;
  bool isAsc;
  String? sortBy;
  String? text;

  UsersDto({
    this.page = 1,
    this.pageSize = Constant.LIST_PAGE_SIZE,
    this.isFollowed = false,
    this.isAsc = false,
    this.sortBy,
    this.text,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        page,
        pageSize,
        isFollowed,
        isAsc,
        sortBy,
        text,
      ];

  @override
  bool get stringify {
    return true;
  }
}
