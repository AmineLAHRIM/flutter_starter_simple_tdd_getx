import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/pagination_dto.dart';
import 'package:flutter_starter/data/models/dto/users_dto.dart';
import 'package:flutter_starter/data/models/invitation_request.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/models/user.dart';

abstract class FriendRepo {
  Future<Either<Failure, Pagination<User>>> getFriends({
    required PaginationDto paginationDto,
  });

  Future<Either<Failure, Pagination<User>>> getAvailableUsers({
    required UsersDto? usersParams,
  });

  Future<Either<Failure, Pagination<User>>> getBlockedUsers({
    required PaginationDto paginationDto,
  });

  Future<Either<Failure, Pagination<InvitationRequest>>> getSentRequests({
    required PaginationDto paginationDto,
  });

  Future<Either<Failure, InvitationRequest>> sentRequest({
    required int userId,
  });

  Future<Either<Failure, Pagination<InvitationRequest>>> getReceivedRequests({
    required PaginationDto paginationDto,
  });

  Future<Either<Failure, InvitationRequest>> getReceivedRequest({
    required int invitationRequestId,
  });
}
