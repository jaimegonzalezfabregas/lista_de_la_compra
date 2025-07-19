const int millisCorrectionToEpoc = 342000000;
const int millisInAWeek = 1000 * 60 * 60 * 24 * 7;

int getCurrentWeek() {
  return ((DateTime.now().millisecondsSinceEpoch - millisCorrectionToEpoc) /
          millisInAWeek)
      .floor();
}

DateTime getStartOfWeek(int week) {
  return DateTime.fromMillisecondsSinceEpoch(
    week * millisInAWeek + millisCorrectionToEpoc,
  );
}

DateTime weekAndDayToDateTime(int week, int day) {
  return DateTime.fromMillisecondsSinceEpoch(
    week * millisInAWeek + millisCorrectionToEpoc + day * 1000 * 60 * 60 * 24,
  );
}
