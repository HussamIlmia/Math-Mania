import 'package:flutter/foundation.dart';

class TimingService {
  final Stopwatch _stopwatch = Stopwatch();
  int? _startAt;

  int start() {
    _stopwatch.reset();
    _startAt = DateTime.now().millisecondsSinceEpoch;
    _stopwatch.start();
    return _startAt!;
  }

  int startedAt() => _startAt ?? DateTime.now().millisecondsSinceEpoch;

  int end() {
    if (!_stopwatch.isRunning) {
      return 0;
    }
    _stopwatch.stop();
    return _stopwatch.elapsed.inMilliseconds;
  }

  int endAt() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return now;
  }

  void reset() {
    _stopwatch.reset();
    _startAt = null;
  }
}
