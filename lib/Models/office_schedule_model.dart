class OfficeScheduleModel {
  final String title;

  final DateTime date;
  final String time;

  OfficeScheduleModel({
    required this.title,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
    };
  }

  factory OfficeScheduleModel.fromMap(Map<String, dynamic> map) {
    return OfficeScheduleModel(
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: map['time'],
    );
  }
}
