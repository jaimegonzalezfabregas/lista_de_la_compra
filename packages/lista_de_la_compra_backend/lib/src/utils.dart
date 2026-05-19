const int UnixEpochWasNotAMondayCorrection = 342000000;
const int millisInADay = 1000 * 60 * 60 * 24;
const int millisInAWeek = millisInADay * 7;

int getCurrentWeek() {
  return ((DateTime.now().millisecondsSinceEpoch - UnixEpochWasNotAMondayCorrection) /
          millisInAWeek)
      .floor();
}

int getCurrentDayOfTheWeek(){
  return ((DateTime.now().millisecondsSinceEpoch - UnixEpochWasNotAMondayCorrection) % millisInAWeek / millisInADay).floor();
}

DateTime getStartOfWeek(int week) {
  return DateTime.fromMillisecondsSinceEpoch(
    week * millisInAWeek + UnixEpochWasNotAMondayCorrection,
  );
}

DateTime weekAndDayToDateTime(int week, int day) {
  return DateTime.fromMillisecondsSinceEpoch(
    week * millisInAWeek + UnixEpochWasNotAMondayCorrection + day * 1000 * 60 * 60 * 24,
  );
}
