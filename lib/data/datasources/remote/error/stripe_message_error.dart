import 'package:equatable/equatable.dart';

class StripeMessageError extends Equatable {
  StripeError? error;

  StripeMessageError({this.error});

  StripeMessageError.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new StripeError.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class StripeError extends Equatable {
  String? code;
  String? docUrl;
  String? message;
  String? type;

  StripeError({this.code, this.docUrl, this.message, this.type});

  StripeError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    docUrl = json['doc_url'];
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['doc_url'] = this.docUrl;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [code, docUrl, message, type];
}
