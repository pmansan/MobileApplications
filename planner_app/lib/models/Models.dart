class Activity {
  final String title;
  final DateTime time;
  final int day;

  Activity({
    required this.title,
    required this.time,
    this.day = 0,
  });
}

class Travel {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  late final String? imageURL;

  Travel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.imageURL,
  });

  Duration get duration => endDate.difference(startDate);
}

 String capitalize(String text) {
  return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : '';
}
