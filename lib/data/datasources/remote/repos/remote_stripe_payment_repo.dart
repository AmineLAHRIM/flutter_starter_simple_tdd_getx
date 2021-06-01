import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/remote/error/remote_message_error.dart';
import 'package:flutter_starter/data/models/dto/refund_dto.dart';
import 'package:flutter_starter/data/models/stripe_checkout_response.dart';
import 'package:flutter_starter/data/models/stripe_payment.dart';

abstract class RemoteStripePaymentRepo {
  Future<StripeCheckoutResponse> generateCheckoutSessionId({
    required String secretKey,
    required StripePayment stripePayment,
    required String accessToken,
  });

  Future<bool> createRefund({
    required RefundDto? refundParams,
    required String accessToken,
  });
}

@Injectable(as: RemoteStripePaymentRepo)
class RemoteStripePaymentRepoImpl implements RemoteStripePaymentRepo {
  Dio? dio;

  RemoteStripePaymentRepoImpl(this.dio);

  @override
  Future<StripeCheckoutResponse> generateCheckoutSessionId({String? secretKey, required StripePayment stripePayment, required String accessToken}) async {
    // TODO: implement generateCheckoutInfo
    try {
      print('[track generateCheckoutSessionId] SENT');

      final response = await dio!.post('/user/stripe/create_checkout/',
          data: stripePayment.toJson(),
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
          ));
      print('[track generateCheckoutSessionId] RECIVED ${response.statusCode}');

      // as Map<String,dynamic> not json string as response.body of http package

      final responseData = response.data;

      if (response.statusCode == 200) {
        //return responseData['id'];
        final stripeCheckoutResponse = StripeCheckoutResponse.fromJson(responseData);
        return stripeCheckoutResponse;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      var message = Messages.LIMIT_FREE_TICKET;
      if (e.response?.data != null && e.response!.data['message'] != null) {
        //message response as PURCHASED_FREE_TICKET_COUNT/AVALAIBLE_TO_PURCHASE_FREE_TICKET_COUNT
        var messages = e.response!.data['message'].split('/');
        var purchasedFreeTicketCount;
        var avalaibleFreeTicketCount;
        if (e.response!.data['code'] == Messages.CODE_ALLOCATION_CONSUPTION_NOT_POSSIBLE) {
          purchasedFreeTicketCount = int.tryParse(messages.first);
          if (purchasedFreeTicketCount != null) message = 'For this event, You have already purchased all $purchasedFreeTicketCount avalaible free tickets.';
        } else if (e.response!.data['code'] == Messages.CODE_ORDERED_QTY_GREATER_THAN_REQUESTED_QTY) {
          purchasedFreeTicketCount = int.tryParse(messages.first);
          avalaibleFreeTicketCount = int.tryParse(messages.last);
          if (purchasedFreeTicketCount != null && avalaibleFreeTicketCount != null) {
            if (purchasedFreeTicketCount == 0) {
              message = 'For this event, You can only purchase a limit of $avalaibleFreeTicketCount tickets';
            } else {
              if (avalaibleFreeTicketCount > 0) {
                message = 'For this event, You have already purchased $purchasedFreeTicketCount free tickets, You can still only purchase $avalaibleFreeTicketCount ticket now.';
              } else {
                message = 'For this event, You have already purchased all free tickets.';
              }
            }
          }
        }
      }
      //possible errors
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 4, message: Messages.SOCIETY_HAVE_NO_STRIPE),
        RemoteMessageError(code: Messages.CODE_ALLOCATION_CONSUPTION_NOT_POSSIBLE, message: message),
        RemoteMessageError(code: Messages.CODE_ORDERED_QTY_GREATER_THAN_REQUESTED_QTY, message: message),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors);
    }
  }

  @override
  Future<bool> createRefund({RefundDto? refundParams, required String accessToken}) async {
    // TODO: implement createRefund
    try {
      final response = await dio!.post('/user/stripe/order_refund/',
          data: refundParams!.toJson(),
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
          ));
      // as Map<String,dynamic> not json string as response.body of http package

      final responseData = response.data;

      if (response.statusCode == 200) {
        //return responseData['id'];
        return true;
      } else {
        throw DioError(response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      List<RemoteMessageError> rmerrors = [
        RemoteMessageError(code: 34, message: Messages.EVENT_UNREFUNDABLE_MSG),
        RemoteMessageError(code: 37, message: Messages.ALREADY_REFUNDED),
        RemoteMessageError(code: 39, message: Messages.FREE_EVENT_MSG),
      ];
      throw RemoteException(e: e, rmerrors: rmerrors);
    }
  }

  @override
  Future<String> generatePriceId({String? secretKey, StripePayment? stripePayment}) {
    // TODO: implement generatePriceId
    throw UnimplementedError();
  }
}
