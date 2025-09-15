class ReservationDataModel {
  int? id;
  int caregiverId;
  int tutorId;
  String date;
  String startTime;
  String endTime;
  String? status;
  double totalAmount;
  ReservationDataModel({
    this.id,
    required this.caregiverId,
    required this.tutorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status,
    required this.totalAmount,
  });

  static ReservationDataModel objJson(Map<String, dynamic> json) {
    try {
      return ReservationDataModel(
        id: _parseInt(json['id']),
        caregiverId: _parseInt(json['caregiverId']) ?? _parseInt(json['caregiver_id']) ?? 0,
        tutorId: _parseInt(json['tutorId']) ?? _parseInt(json['tutor_id']) ?? 0,
        date: json['date']?.toString() ?? '',
        startTime: json['startTime']?.toString() ?? json['start_time']?.toString() ?? '',
        endTime: json['endTime']?.toString() ?? json['end_time']?.toString() ?? '',
        status: json['status']?.toString(),
        totalAmount: _parseDouble(json['totalAmount']) ??
            _parseDouble(json['total_amount']) ??
            _parseDouble(json['amount']) ?? 0.0,
      );
    } catch (e) {
      print('Error parsing ReservationDataModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Función helper para parsear enteros de manera segura
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) return value.toInt();
    return null;
  }

  // Función helper para parsear doubles de manera segura
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  // Método para debugging
  @override
  String toString() {
    return 'ReservationDataModel{id: $id, caregiverId: $caregiverId, tutorId: $tutorId, date: $date, startTime: $startTime, endTime: $endTime, status: $status, totalAmount: $totalAmount}';
  }

  Map<String, dynamic> toJson() {
    String formattedStartDateTime = '${date}T${startTime}:00';
    String formattedEndDateTime = '${date}T${endTime}:00';
    String formattedDateTime = '${date}T${startTime}:00'; // usar misma hora que startTime o una estándar

    return {
      'id': id,
      'caregiverId': caregiverId,
      'tutorId': tutorId,
      'date': formattedDateTime,
      'startTime': formattedStartDateTime,
      'endTime': formattedEndDateTime,
      'status': status,
      'totalAmount': totalAmount,
    };
  }

}