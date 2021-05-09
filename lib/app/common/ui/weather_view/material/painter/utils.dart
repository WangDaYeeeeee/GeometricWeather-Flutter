class IntervalComputer {

  int _currentTime;
  int _lastTime;
  double _interval;

  IntervalComputer() {
    reset();
  }

  void reset() {
    _currentTime = -1;
    _lastTime = -1;
    _interval = 0;
  }

  double invalidate() {
    _currentTime = DateTime.now().millisecondsSinceEpoch;
    _interval = _lastTime == -1 ? 0 : (_currentTime - _lastTime).toDouble();
    _lastTime = _currentTime;

    return _interval;
  }
}