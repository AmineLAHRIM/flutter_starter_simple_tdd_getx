class StripeCheckoutResponse {
  DataStripeChechkout? data;
  String? message;

  StripeCheckoutResponse({this.data, this.message});

  StripeCheckoutResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataStripeChechkout.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class DataStripeChechkout {
  String? stripePublishableKey;
  String? stripeSessionId;

  DataStripeChechkout({this.stripePublishableKey, this.stripeSessionId});

  DataStripeChechkout.fromJson(Map<String, dynamic> json) {
    stripePublishableKey = json['stripe_publishable_key'];
    stripeSessionId = json['stripe_session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_publishable_key'] = this.stripePublishableKey;
    data['stripe_session_id'] = this.stripeSessionId;
    return data;
  }
}
