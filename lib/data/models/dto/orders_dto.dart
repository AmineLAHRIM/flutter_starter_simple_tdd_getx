import 'package:equatable/equatable.dart';
import 'package:flutter_starter/config/constant.dart';

class OrdersDto extends Equatable {
  int page;
  int pageSize;
  bool upcoming;
  bool old;

  OrdersDto({
    this.page = 1,
    this.pageSize = Constant.LIST_PAGE_SIZE,
    this.upcoming = false,
    this.old = false,
  });

  @override
  // TODO: implement props
  List<Object> get props => [page, pageSize, upcoming, old];
}
