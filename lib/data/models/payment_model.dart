/// A payment or account statement entry.
class PaymentModel {
  final String id;
  final String concept;
  final double amount;
  final String date;
  final String status; // "Pagado", "Pendiente"
  final String? method;
  final String? reference;

  const PaymentModel({
    required this.id,
    required this.concept,
    required this.amount,
    required this.date,
    required this.status,
    this.method,
    this.reference,
  });

  bool get isPaid => status == 'Pagado';

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      concept: json['concept'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      status: json['status'] as String,
      method: json['method'] as String?,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'concept': concept,
    'amount': amount,
    'date': date,
    'status': status,
    'method': method,
    'reference': reference,
  };
}

/// An academic program offered by UNAD.
class ProgramModel {
  final String id;
  final String name;
  final String faculty;
  final int credits;
  final String duration;
  final int students;
  final String status;

  const ProgramModel({
    required this.id,
    required this.name,
    required this.faculty,
    required this.credits,
    required this.duration,
    required this.students,
    this.status = 'Activo',
  });

  ProgramModel copyWith({
    String? id,
    String? name,
    String? faculty,
    int? credits,
    String? duration,
    int? students,
    String? status,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      name: name ?? this.name,
      faculty: faculty ?? this.faculty,
      credits: credits ?? this.credits,
      duration: duration ?? this.duration,
      students: students ?? this.students,
      status: status ?? this.status,
    );
  }

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String,
      name: json['name'] as String,
      faculty: json['faculty'] as String,
      credits: json['credits'] as int,
      duration: json['duration'] as String,
      students: json['students'] as int? ?? 0,
      status: json['status'] as String? ?? 'Activo',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'faculty': faculty,
    'credits': credits,
    'duration': duration,
    'students': students,
    'status': status,
  };
}

/// A notification in the system.
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String
  type; // "grade", "payment", "announcement", "request", "message", "calendar"
  final String icon;
  final String iconBg;
  final String iconColor;
  final String time;
  final bool unread;
  final DateTime? timestamp;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.icon = 'Bell',
    this.iconBg = 'bg-gray-50',
    this.iconColor = 'text-gray-500',
    required this.time,
    this.unread = true,
    this.timestamp,
  });

  NotificationModel copyWith({bool? unread}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      time: time,
      unread: unread ?? this.unread,
      timestamp: timestamp,
    );
  }
}

/// An academic period (semester).
class AcademicPeriodModel {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String status; // "Abierto", "Cerrado", "Planificación"
  final bool enrollmentOpen;

  const AcademicPeriodModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.enrollmentOpen = false,
  });

  AcademicPeriodModel copyWith({String? status, bool? enrollmentOpen}) {
    return AcademicPeriodModel(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      status: status ?? this.status,
      enrollmentOpen: enrollmentOpen ?? this.enrollmentOpen,
    );
  }

  factory AcademicPeriodModel.fromJson(Map<String, dynamic> json) {
    return AcademicPeriodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      status: json['status'] as String,
      enrollmentOpen: json['enrollment_open'] as bool? ?? false,
    );
  }
}
