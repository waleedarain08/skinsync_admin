List<Map<String, String>> getNextNDays(int n) {
  final now = DateTime.now();
  final List<Map<String, String>> dates = [];

  for (int i = 0; i < n; i++) {
    final date = now.add(Duration(days: i));
    final dayInitial = _getDayString(date.weekday);
    dates.add({
      'date': date.day.toString().padLeft(2, '0'),
      'day': dayInitial, // or dayInitial if you want short "Mon", "Tue"
    });
  }

  return dates;
}

String formatDateTime(DateTime? dateTime, {bool includeTime = false, String timeSeparator = ' | '}) {
  if (dateTime == null) return 'N/A';
  final dateStr = '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}';
  if (includeTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$dateStr$timeSeparator$hour:$minute $period';
  }
  return dateStr;
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

String _getDayString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
}
