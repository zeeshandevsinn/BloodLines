import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

getTimeMethod(String dateTime) {
  DateTime date = DateTime.now();
  String? today;
  String? times;
  final DateFormat formatter = DateFormat('yy/MM/dd');
  final DateFormat timeFormatter = DateFormat('hh:mm aa');
  DateTime d = DateTime.parse(dateTime);
  var difference = DateOnlyCompare(date).isSameDate(d);
  if (difference == false) {
    var time = d.difference(date).inDays;
    var min = d.difference(date).inMinutes;
    if (time == 0) {
      times = timeFormatter.format(DateTime.parse(dateTime));
      if (min < 0) {
        min = min * -1;
      }
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "$m Hour ago";
        } else {
          return "$m Hours ago";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "$min Mins ago";
      }
    } else if (time <= -1 && time > -364) {
      time = time * -1;
      times = timeFormatter.format(DateTime.parse(dateTime));
      if (time == 1) {
        today = "$time day ago";
      } else {
        today = "$time days ago";
      }
      return today;
    } else if (time < -364) {
      times = timeFormatter.format(DateTime.parse(dateTime));
      today = formatter.format(DateTime.parse(dateTime));

      return today;
    } else {
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "$m Hour ago";
        } else {
          return "$m Hours ago";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "$min Mins ago";
      }
    }
  } else {
    times = timeFormatter.format(DateTime.parse(dateTime));
    today = times;
    return today;
  }
}

getLastSeenMethod(String dateTime) {
  DateTime date = DateTime.now().toLocal();
  String? today;
  String? times;
  final DateFormat formatter = DateFormat('yy/MM/dd');
  final DateFormat timeFormatter = DateFormat('hh:mm aa');
  DateTime d = DateTime.parse(dateTime).toLocal();
  var difference = DateOnlyCompare(date).isSameDate(d);
  if (difference == false) {
    var time = d.difference(date).inDays;
    var min = d.difference(date).inMinutes;
    if (time == 0) {
      times = timeFormatter.format(DateTime.parse(dateTime));
      if (min < 0) {
        min = min * -1;
      }
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "at ${m}h ago";
        } else {
          return "at ${m}h ago";
        }
      } else {
        if (min <= 1) {
          return "just now";
        }
        return "at ${min}m ago";
      }
    } else if (time <= -1 && time > -364) {
      time = time * -1;
      times = timeFormatter.format(DateTime.parse(dateTime));
      if (time == 1) {
        today = "at $time days ago";
      } else {
        today = "at $time days ago";
      }
      return today;
    } else if (time < -364) {
      times = timeFormatter.format(DateTime.parse(dateTime));
      today = formatter.format(DateTime.parse(dateTime));

      return today;
    } else {
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "at ${m}h ago";
        } else {
          return "at ${m}h ago";
        }
      } else {
        if (min <= 1) {
          return "just now";
        }
        return "at ${min}m ago";
      }
    }
  } else {
    times = timeFormatter.format(d);
    today = times;
    return today;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

String inputFormatter(var message) {
  if (message.toString().startsWith(RegExp(r'^\n+'))) {
    return message.toString().replaceAll(RegExp(r'^\n+'), "");
  } else if (message.toString().endsWith("\n") ||
      message.toString().startsWith(RegExp(r"^\s+")) ||
      message.toString().endsWith(" ")) {
    message = message.toString().replaceFirst(RegExp(r"^\s+"), "");
    return message.toString().replaceFirst(RegExp(r"\s+$"), "");
  } else {
    return message;
  }
}

class ItemModel {
  String title;
  IconData icon;
  ItemModel(this.title, this.icon);
}
