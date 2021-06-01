import 'package:intl/intl.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/data/models/event.dart';

extension DateExtension on Event {
  String get eventDate {
    if (this != null) {
      final dateFormat = DateFormat('EEE d MMM | hh:mm a');
      //final dateFormat = DateFormat('dd.MM.yy | hh:mm a');
      var dateText = this.startDate != null ? dateFormat.format(this.startDate!).toUpperCase() : '';
      final isEventStared = this.startDate!.isBefore(DateTime.now());
      final isEventEnded = this.endDate!.isBefore(DateTime.now());
      if (isEventStared) {
        if (isEventEnded) {
          //dateText = Messages.EVENT_ENDED.toUpperCase();
        } else {
          dateText = Messages.EVENT_LIVE.toUpperCase();
        }
      } else {
        final diffDuration = this.startDate!.difference(DateTime.now());
        if (diffDuration.inDays > 0 && diffDuration.inDays <= Constant.DURATION_EVENT_COUNTDOWN.inDays) {
          //dateText = '${diffDuration.inDays} days left | ${dateFormat2.format(this.startDate)}'.toUpperCase();
          //dateText = 'Starting in ${diffDuration.inDays} days'.toUpperCase();
        } else if (diffDuration.inDays == 0) {
          //dateText = '${diffDuration.inHours} hours left '.toUpperCase();
          dateText = 'Starting in ${diffDuration.inHours} hours'.toUpperCase();
        }
      }

      return dateText;
    }
    return '';
  }
}
