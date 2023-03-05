class SpeedcubingTimer {
  final stopwatch = Stopwatch();

  void startTimer() {
    stopwatch.reset();
    stopwatch.start();
  }

  void stopTimer() {
    stopwatch.stop();
  }

  int getTime () => stopwatch.elapsedMilliseconds;
}