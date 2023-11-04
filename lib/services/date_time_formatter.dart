import 'package:intl/intl.dart';

String timeAgo(DateTime time) {
  Duration diff = DateTime.now().difference(time);

  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return DateFormat.E().add_jm().format(time);
  }
  if (diff.inHours > 0) {
    return "Today ${DateFormat('jm').format(time)}";
  }
  // if (diff.inHours > 0) {
  //   return "${(diff.inHours).floor()} hours ago ${DateFormat('jm').format(time)}";
  // }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "Just now";
}
