import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/data/models/stripe_checkout_response.dart';
import 'package:flutter_starter/data/models/stripe_payment.dart';
import 'package:flutter_starter/data/repos/abstract/stripe_payment_repo.dart';

/// Only for demo purposes!
@lazySingleton
class StripePaymentService {
  StripePaymentRepo? stripePaymentRepo;

  StripePaymentService({this.stripePaymentRepo});

  Future<Either<Failure, StripeCheckoutResponse>> createCheckout({List<LineItem>? lineItems, int? eventId}) async {
    final stripePayment = StripePayment(
      eventId: eventId,
      lineItems: lineItems /*[
        LineItem(name: 'Standard', quantity: 1, currency: 'usd', amount: '200'),
        LineItem(name: 'Gold', quantity: 1, currency: 'usd', amount: '40000'),
      ]*/
      ,
      successUrl: Constant.SUCCESS_URL,
      cancelUrl: Constant.FAILURE_URL,
    );

    final failureOrResult = await this.stripePaymentRepo!.generateCheckoutSessionId(secretKey: Constant.STRIPE_SECRET_KEY, stripePayment: stripePayment);
    return failureOrResult;
  }
}
