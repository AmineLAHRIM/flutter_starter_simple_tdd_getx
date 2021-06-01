import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/order_dto.dart';
import 'package:flutter_starter/data/models/dto/orders_dto.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/models/ticket_order.dart';

abstract class OrderRepo {
  Future<Either<Failure, Pagination<TicketOrder>>> getOrders({OrdersDto? ordersDto});

  Future<Either<Failure, TicketOrder>> orderFreeTicket({required OrderDto orderDto});
}
