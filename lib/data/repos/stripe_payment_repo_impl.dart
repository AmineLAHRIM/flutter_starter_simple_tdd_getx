import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/network/network_info.dart';
import 'package:flutter_starter/data/datasources/local/repos/local_user_repo.dart';
import 'package:flutter_starter/data/datasources/remote/repos/remote_stripe_payment_repo.dart';
import 'package:flutter_starter/data/models/dto/refund_dto.dart';
import 'package:flutter_starter/data/models/stripe_checkout_response.dart';
import 'package:flutter_starter/data/models/stripe_payment.dart';
import 'package:flutter_starter/data/repos/abstract/stripe_payment_repo.dart';

@Injectable(as: StripePaymentRepo)
class StripePaymentRepoImpl implements StripePaymentRepo {
  NetworkInfo? networkInfo;
  RemoteStripePaymentRepo? remoteStripePaymentRepo;
  LocalUserRepo? localUserRepo;

  StripePaymentRepoImpl({this.networkInfo, this.remoteStripePaymentRepo, this.localUserRepo});

  @override
  Future<Either<Failure, StripeCheckoutResponse>> generateCheckoutSessionId({String? secretKey, StripePayment? stripePayment}) async {
    // TODO: implement generateCheckoutSessionId
    if (secretKey == null || stripePayment == null) {
      return Left(StripeCheckoutFailure(Messages.EVENT_NOT_EXISTS_FOR_PURCHASE));
    }
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.access != null) {
          final sessionId = await this.remoteStripePaymentRepo!.generateCheckoutSessionId(secretKey: secretKey, stripePayment: stripePayment, accessToken: localUser!.access!);
          return Right(sessionId);
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
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createRefund({RefundDto? refundParams}) async {
    // TODO: implement createRefund
    if (await networkInfo!.isConnected) {
      try {
        final localUser = this.localUserRepo!.findCachedUser();
        if (localUser?.access != null) {
          final isDone = await this.remoteStripePaymentRepo!.createRefund(refundParams: refundParams, accessToken: localUser!.access!);
          return Right(isDone);
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
      return Left(ConnectionFailure());
    }
  }
}
