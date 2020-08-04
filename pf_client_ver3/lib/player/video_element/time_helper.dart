class TimeHelper {
  /// 转换时间格式，例如：01:20:54、20:54
  static String getTimeText(double seconds) {
    var duration = Duration(milliseconds: (seconds * 1000).toInt());

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

    var str = "$twoDigitMinutes:$twoDigitSeconds";

    if (duration.inHours == 0) {
      return str;
    }
    //FIXME:移除时间补齐
    var hour = duration.inHours.toString(); //.padLeft(2, "0");
    return "$hour:$str";
  }
}
