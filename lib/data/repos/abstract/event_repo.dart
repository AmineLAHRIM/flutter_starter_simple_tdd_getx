import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/events_dto.dart';
import 'package:flutter_starter/data/models/enums/distance_unit.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/favourite.dart';
import 'package:flutter_starter/data/models/pagination.dart';

abstract class EventRepo {
  Future<Either<Failure, Pagination<Event>>> getEvents({EventsDto? eventsDto});

  Future<Either<Failure, Either<Favourite, Event?>>> setFavourite({required int eventId, bool? isFavourite = false, EventsDto? eventsDto});

  Future<Either<Failure, Event>> getEvent({required int eventId});

  Future<Either<Failure, DistanceUnit>> getDistanceUnit();

  Future<Either<Failure, bool>> saveDistanceUnit({DistanceUnit? distanceUnit});
}
