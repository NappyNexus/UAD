import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_data.dart';

// --- Announcements Provider ---

class AnnouncementsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AnnouncementsNotifier() : super(List.from(announcements));

  void addAnnouncement(Map<String, dynamic> announcement) {
    state = [announcement, ...state];
  }

  void togglePin(int id) {
    state = [
      for (final ann in state)
        if (ann['id'] == id)
          {...ann, 'pinned': !(ann['pinned'] as bool)}
        else
          ann,
    ];
  }

  void deleteAnnouncement(int id) {
    state = state.where((ann) => ann['id'] != id).toList();
  }
}

final announcementsProvider =
    StateNotifierProvider<AnnouncementsNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return AnnouncementsNotifier();
    });

// --- Calendar Events Provider ---

class CalendarEventsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CalendarEventsNotifier() : super(_initialEvents);

  static final List<Map<String, dynamic>> _initialEvents = [
    {
      'id': 'EVT-001',
      'title': 'Examen Parcial 1',
      'date': DateTime(2024, 10, 15, 8, 0),
      'type': 'examen',
      'courseId': 'MAT-301',
      'time': '08:00 AM',
      'notes': 'Traer calculadora científica.',
    },
    {
      'id': 'EVT-002',
      'title': 'Entrega de Proyecto',
      'date': DateTime(2024, 10, 20, 23, 59),
      'type': 'entrega',
      'courseId': 'MAT-401',
      'time': '11:59 PM',
      'notes': 'Subir a la plataforma en formato PDF.',
    },
  ];

  void addEvent(Map<String, dynamic> event) {
    state = [...state, event];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e['id'] != id).toList();
  }
}

final calendarEventsProvider =
    StateNotifierProvider<CalendarEventsNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return CalendarEventsNotifier();
    });

// --- Grade Revisions Provider ---

class GradeRevisionsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  GradeRevisionsNotifier() : super(_initialRevisions);

  static final List<Map<String, dynamic>> _initialRevisions = [
    {
      'id': 1,
      'studentId': '2022-5434',
      'studentName': 'María Elena Rodríguez',
      'courseId': 'MAT-301',
      'courseName': 'Cálculo III',
      'partial': 'Parcial 1',
      'currentGrade': 75,
      'requestedGrade': 82,
      'reason': 'Creo que mi ejercicio 3 fue corregido incorrectamente.',
      'date': '2024-10-12',
      'status': 'pending',
      'response': null,
    },
  ];

  void updateStatus(int id, String status, String? response) {
    state = [
      for (final req in state)
        if (req['id'] == id)
          {...req, 'status': status, 'response': response}
        else
          req,
    ];
  }

  void addRequest(Map<String, dynamic> request) {
    state = [request, ...state];
  }
}

final gradeRevisionsProvider =
    StateNotifierProvider<GradeRevisionsNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return GradeRevisionsNotifier();
    });

// --- Students Provider ---

class ProfessorStudentsNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  ProfessorStudentsNotifier() : super(List.from(professorStudents));

  void updateGrade(String id, Map<String, dynamic> grades) {
    state = [
      for (final s in state)
        if (s['id'] == id) {...s, ...grades} else s,
    ];
  }
}

final professorStudentsProvider =
    StateNotifierProvider<
      ProfessorStudentsNotifier,
      List<Map<String, dynamic>>
    >((ref) {
      return ProfessorStudentsNotifier();
    });
