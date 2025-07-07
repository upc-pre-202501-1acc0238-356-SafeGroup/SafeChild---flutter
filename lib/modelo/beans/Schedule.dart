import 'ScheduleShift.dart';

class Schedule {
  final int? id;
  final int? caregiverId;
  final String availableDate;
  final List<ScheduleShift> scheduleShifts;

  Schedule({
    this.id,
    this.caregiverId,
    required this.availableDate,
    required this.scheduleShifts,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      caregiverId: json['caregiverId'],
      availableDate: json['availableDate'],
      scheduleShifts: (json['scheduleShifts'] as List)
          .map((e) => ScheduleShift.fromJson(e))
          .toList(),
    );
  }
}