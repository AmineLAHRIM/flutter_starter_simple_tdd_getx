import 'package:dartz/dartz.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/dto/refund_dto.dart';
import 'package:flutter_starter/data/models/stripe_checkout_response.dart';
import 'package:flutter_starter/data/models/stripe_payment.dart';

abstract class StripePaymentRepo {
  Future<Either<Failure, StripeCheckoutResponse>> generateCheckoutSessionId({
    required String secretKey,
    required StripePayment stripePayment,
  });

  Future<Either<Failure, bool>> createRefund({
    required RefundDto? refundParams,
  });
}
