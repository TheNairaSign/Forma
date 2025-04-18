List<DateTime> getWeekDays() {
    final selectedDate = DateTime.now();
    final firstDayOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }