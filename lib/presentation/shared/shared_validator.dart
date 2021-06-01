import 'package:get/get.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/data/models/university.dart';

class SharedValidator {
  var isSubmitted = false;

  String? validateEmail(String? value) {
    value = value!.trim();
    /*Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return Messages.REQUIRED;
    } else if (!regex.hasMatch(value))
      return Messages.ENTER_VALID_EMAIL;
    else
      return null;*/
    if (value.isEmpty) {
      return Messages.REQUIRED;
    } else if (!GetUtils.isEmail(value.trim()))
      return Messages.ENTER_VALID_EMAIL;
    else
      return null;
  }

  String? validateCode(String? value) {
    if (isSubmitted) {
      return null;
    }

    var hasLetters = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value!.trim());

    if (value.isEmpty) {
      return Messages.REQUIRED;
    } else if (!hasLetters) {
      return Messages.ONLY_LETTER_AND_NUMBER;
    }
    return null;
  }

  String? validateName(String? value) {
    if (isSubmitted) {
      return null;
    }

    var hasLetters = RegExp(r'^[a-zA-Z]+$').hasMatch(value!.trim());

    if (value.isEmpty) {
      return Messages.REQUIRED;
    } else if (!hasLetters) {
      return Messages.ONLY_LETTERS;
    }
    return null;
  }

  String? validateNoRequiredName(String? value) {
    if (isSubmitted) {
      return null;
    }

    var hasLetters = RegExp(r'^[ a-zA-Z]+$').hasMatch(value!.trim());

    if (value.isEmpty) {
      return null;
    } else if (!hasLetters) {
      return Messages.ONLY_LETTERS;
    }
    return null;
  }

  String? validateUniversity(University value) {
    if (isSubmitted) {
      return null;
    }
    if (value == null) {
      return Messages.REQUIRED;
    }
    return null;
  }

  String? validateEmpty(String? value) {
    if (isSubmitted) {
      return null;
    }

    if (value!.isEmpty) {
      return Messages.REQUIRED;
    }
    return null;
  }
}
