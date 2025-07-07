class ScheduleShift {
  final int? id;
  final String shift;
  final bool available;

  ScheduleShift({
    this.id,
    required this.shift,
    required this.available,
  });

  factory ScheduleShift.fromJson(Map<String, dynamic> json) {
    return ScheduleShift(
      id: json['id'],
      shift: json['shift'],
      available: json['available'],
    );
  }
}