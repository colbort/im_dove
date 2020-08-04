import 'package:logger/logger.dart';
import 'dart:convert';

// printTime: false, sinceTime: false
final log = Logger(
  printer: _Printer(printTime: true, printSince: false, color: false),
);

class _Printer extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = "${ansiEsc}0m";

  static final levelColors = {
    Level.verbose: 232,
    Level.debug: 44,
    Level.info: 12,
    Level.warning: 208,
    Level.error: 196,
    Level.wtf: 199,
  };

  var _printTime = false;
  var _printSince = false;
  var _color = false;
  final _startTime = DateTime.now();

  _Printer({printTime = false, printSince = false, color = false}) {
    _printTime = printTime;
    _printSince = printSince;
    _color = color;
    Logger.level = Level.warning;

    /// dev 环境下的 级别
    assert(() {
      Logger.level = Level.verbose;
      return true;
    }());
  }

  @override
  void log(LogEvent event) {
    var msg = _stringifyMessage(event.message);
    var estr = event.error != null ? " ERROR: ${event.error}" : "";
    var out = '';
    if (_printTime) {
      out += _getTime();
    }

    if (_printSince) {
      out += _getSince();
    }

    out +=
        "${_color ? _getColor(event.level) : ''}${levelPrefixes[event.level]} $msg$estr${_color ? ansiDefault : ''}";
    // out += "${levelPrefixes[event.level]} $msg$estr";
    println(out);
  }

  String _stringifyMessage(dynamic msg) {
    if (msg is Map || msg is Iterable) {
      return JsonEncoder.withIndent(null).convert(msg);
    } else {
      return msg.toString();
    }
  }

  String _getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return "$n";
      if (n >= 10) return "0$n";
      return "00$n";
    }

    String _twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    var now = DateTime.now();
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);

    return "$h:$min:$sec.$ms ";
  }

  String _getSince() {
    return '(+${DateTime.now().difference(_startTime).toString()}) ';
  }

  String _getColor(Level l) {
    return "${ansiEsc}38;5;${levelColors[l]}m";
  }
}
