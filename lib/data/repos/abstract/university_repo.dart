import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/university_dto.dart';
import 'package:flutter_starter/data/models/pagination.dart';
import 'package:flutter_starter/data/models/university.dart';

abstract class UniversityRepo {
  /*
  * get all universities
  * */
  Future<Either<Failure, Pagination<University>>> getUniversities({UniversitiesDto? universitiesParams});
}
