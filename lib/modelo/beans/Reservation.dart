class Reservation {
  final int? id;
  final int caregiverId;
  final int tutorId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final num totalAmount;

  Reservation({
    this.id,
    required this.caregiverId,
    required this.tutorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      caregiverId: json['caregiverId'],
      tutorId: json['tutorId'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregiverId': caregiverId,
      'tutorId': tutorId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'totalAmount': totalAmount,
    };
  }
}