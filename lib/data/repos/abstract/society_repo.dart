import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/pagination_dto.dart';
import 'package:flutter_starter/data/models/dto/societies_dto.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/models/society.dart';
import 'package:flutter_starter/data/models/user.dart';

abstract class SocietyRepo {
  Future<Either<Failure, Pagination<Society>>> getSocieties({SocietiesDto? societiesDto});

  Future<Either<Failure, Pagination<Society>>> getFollowedSocieties({required int userId, SocietiesDto? societiesDto});

  Future<Either<Failure, Society>> getSociety({required int societyId});

  Future<Either<Failure, bool>> setFollow({required int societyId, bool? isFollowing});

  Future<Either<Failure, Pagination<User>>> getFollowers({PaginationDto? paginationDto, int? societyId});
}
