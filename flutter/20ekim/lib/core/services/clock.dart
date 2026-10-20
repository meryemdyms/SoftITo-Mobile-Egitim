abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

class TestClock implements Clock {
  DateTime _current;

  TestClock(DateTime initialTime) : _current = initialTime;

  @override
  DateTime now() => _current;

  void setTime(DateTime time) {
    _current = time;
  }

  void advance(Duration duration) {
    _current = _current.add(duration);
  }
}
