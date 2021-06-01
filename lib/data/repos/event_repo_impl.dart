import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/network/network_info.dart';
import 'package:flutter_starter/data/datasources/local/repos/local_event_repo.dart';
import 'package:flutter_starter/data/datasources/local/repos/local_user_repo.dart';
import 'package:flutter_starter/data/datasources/remote/repos/remote_event_repo.dart';
import 'package:flutter_starter/data/models/dto/events_dto.dart';
import 'package:flutter_starter/data/models/enums/distance_unit.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/favourite.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/repos/abstract/event_repo.dart';

@Injectable(as: EventRepo)
class EventRepoImpl implements EventRepo {
  NetworkInfo? networkInfo;
  LocalEventRepo? localEventRepo;
  LocalUserRepo? localUserRepo;
  RemoteEventRepo? remoteEventRepo;

  EventRepoImpl({this.networkInfo, this.localEventRepo, this.remoteEventRepo, this.localUserRepo});

  @override
  Future<Either<Failure, Pagination<Event>>> getEvents({EventsDto? eventsDto}) async {
    // TODO: implement getEvents
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.access != null) {
          final remoteEvents = await this.remoteEventRepo!.findAll(
                accessToken: localUser!.access!,
                eventsDto: eventsDto,
              );
          //localEventRepo.cacheAll(remoteEvents);
          return Right(remoteEvents);
        } else {
          print('[TokenFailure] localUser not exists');
          return Left(TokenFailure());
        }
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      } on TokenException {
        print('[TokenFailure] because of TokenException');
        return Left(TokenFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Either<Favourite, Event?>>> setFavourite({required int eventId, bool? isFavourite = false, EventsDto? eventsDto}) async {
    // TODO: implement setFavourite
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.access != null) {
          if (isFavourite!) {
            final remoteFavourite = await this.remoteEventRepo!.addFavouriteByEventId(
                  accessToken: localUser!.access!,
                  eventId: eventId,
                );
            return Right(Left(remoteFavourite));
          } else {
            final remoteEvent = await this.remoteEventRepo!.deleteFavouriteByEventId(
                  accessToken: localUser!.access!,
                  eventId: eventId,
                  eventsDto: eventsDto,
                );
            return Right(Right(remoteEvent));
          }
        } else {
          return Left(TokenFailure());
        }
      } on HttpException catch (httpException) {
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        return Left(ServerFailure());
      } on TokenException {
        return Left(TokenFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> getEvent({required int eventId}) async {
    // TODO: implement getEvent
    print('[track getEvent] SENT');
    if (await networkInfo!.isConnected) {
      print('[track getEvent] SENT isConnected');
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.access != null) {
          final remoteEvent = await this.remoteEventRepo!.findById(
                eventId: eventId,
                accessToken: localUser!.access!,
              );
          //localEventRepo.cacheAll(remoteEvents);
          print('[track getEvent] RECIVED');
          return Right(remoteEvent);
        } else {
          return Left(TokenFailure());
        }
      } on HttpException catch (httpException) {
        print('[track getEvent] RECIVED');
        return Left(HttpFailure(httpException.remoteMessageError));
      } on ServerException {
        print('[track getEvent] RECIVED');
        return Left(ServerFailure());
      } on TokenException {
        return Left(TokenFailure());
      }
    } else {
      // TODO: implement local user repo
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, DistanceUnit>> getDistanceUnit() async {
    // TODO: implement getDistanceUnit
    try {
      final distanceUnit = this.localEventRepo!.findDistanceUnit();
      return Right(distanceUnit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveDistanceUnit({DistanceUnit? distanceUnit}) async {
    // TODO: implement getDistanceUnit
    try {
      final isCached = await this.localEventRepo!.cacheDistanceUnit(distanceUnit: distanceUnit);
      if (isCached) {
        return Right(true);
      } else {
        return Left(CacheFailure());
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
