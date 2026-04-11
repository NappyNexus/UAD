import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/state/professor_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class CourseCalendarScreen extends ConsumerStatefulWidget {
  const CourseCalendarScreen({super.key});

  @override
  ConsumerState<CourseCalendarScreen> createState() =>
      _CourseCalendarScreenState();
}

class _CourseCalendarScreenState extends ConsumerState<CourseCalendarScreen> {
  final List<Map<String, dynamic>> _eventTypes = [
    {
      'value': 'examen',
      'label': 'Examen',
      'color': AppColors.error,
      'bg': const Color(0xFFFEE2E2),
    },
    {
      'value': 'proyecto',
      'label': 'Proyecto',
      'color': const Color(0xFF9333EA),
      'bg': const Color(0xFFF3E8FF),
    },
    {
      'value': 'entrega',
      'label': 'Entrega',
      'color': AppColors.info,
      'bg': AppColors.infoSurface,
    },
    {
      'value': 'clase_especial',
      'label': 'Clase Especial',
      'color': AppColors.warning,
      'bg': const Color(0xFFFEF3C7),
    },
    {
      'value': 'otro',
      'label': 'Otro',
      'color': AppColors.textSecondary,
      'bg': AppColors.background,
    },
  ];

  String _filter = 'all';
  bool _adding = false;

  String _newCourseId = professorCourses[0]['id'] as String;
  String _newType = 'examen';
  String _newTitle = '';
  String _newDate = '';
  String _newTime = '';
  String _newNotes = '';

  void _handleAdd() {
    if (_newTitle.isEmpty || _newDate.isEmpty) return;
    final newEvent = {
      'id': 'EVT-${DateTime.now().millisecondsSinceEpoch}',
      'courseId': _newCourseId,
      'title': _newTitle,
      'type': _newType,
      'date': DateTime.tryParse(_newDate) ?? DateTime.now(),
      'time': _newTime,
      'notes': _newNotes,
    };
    ref.read(calendarEventsProvider.notifier).addEvent(newEvent);

    setState(() {
      _adding = false;
      _newTitle = '';
      _newDate = '';
      _newTime = '';
      _newNotes = '';
    });
  }

  void _deleteEvent(String id) {
    ref.read(calendarEventsProvider.notifier).deleteEvent(id);
  }

  Map<String, dynamic> _getTypeStyle(String type) => _eventTypes.firstWhere(
    (t) => t['value'] == type,
    orElse: () => _eventTypes.last,
  );

  DateTime _parseDate(dynamic d) {
    if (d is DateTime) return d;
    if (d is String) return DateTime.tryParse(d) ?? DateTime(2024, 10, 15);
    return DateTime(2024, 10, 15);
  }

  int _daysUntil(DateTime date) {
    final cur = DateTime(2024, 10, 15);
    return date.difference(cur).inDays;
  }

  String _daysUntilLabel(int diff) {
    if (diff < 0) return 'Pasado';
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Mañana';
    return 'En $diff días';
  }

  String _getMonthLabel(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getMonth(int m) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(calendarEventsProvider);
    final upcomingList = events.where((e) {
      final date = _parseDate(e['date']);
      return _daysUntil(date) >= 0;
    }).toList();

    final filtered =
        _filter == 'all'
            ? events
            : events.where((e) => e['courseId'] == _filter).toList();

    // Sort by date correctly
    final sorted = List<Map<String, dynamic>>.from(filtered);
    sorted.sort((a, b) {
      final da = _parseDate(a['date']);
      final db = _parseDate(b['date']);
      return da.compareTo(db);
    });

    // Grouping
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final ev in sorted) {
      final date = _parseDate(ev['date']);
      final label = _getMonthLabel(date);
      grouped.putIfAbsent(label, () => []).add(ev);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: PageHeader(
                  title: 'Calendario',
                  subtitle: '${upcomingList.length} eventos próximos',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _adding = !_adding),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text(
                  'Nuevo',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          if (_adding)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nuevo Evento',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CURSO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _newCourseId,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              items: professorCourses
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c['id'] as String,
                                      child: Text(
                                        c['name'] as String,
                                        style: const TextStyle(fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _newCourseId = v!),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TIPO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _newType,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              items: _eventTypes
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t['value'] as String,
                                      child: Text(
                                        t['label'] as String,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _newType = v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => _newTitle = v),
                    decoration: InputDecoration(
                      hintText: 'Título del evento...',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderMedium),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FECHA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: _newDate),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setState(() {
                                    _newDate =
                                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'YYYY-MM-DD',
                                isDense: true,
                                hintStyle: TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HORA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: _newTime),
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _newTime = time.format(context);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'ej. 10:00 AM',
                                isDense: true,
                                hintStyle: TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.borderMedium,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => _newNotes = v),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Notas adicionales (opcional)...',
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderMedium),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _adding = false),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (_newTitle.isEmpty || _newDate.isEmpty)
                            ? null
                            : _handleAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar Evento'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterBtn('all', 'Todos'),
                ...professorCourses.map(
                  (c) => _filterBtn(c['id'] as String, c['name'] as String),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: _eventTypes
                .map(
                  (t) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: t['color'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        t['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),

          // List
          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No hay eventos para mostrar.',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            ),

          ...grouped.entries.map((group) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                  child: Text(
                    group.key.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                ...group.value.map((ev) {
                  final dateValue = _parseDate(ev['date']);
                  final style =
                      _getTypeStyle((ev['type'] ?? 'otro').toString());
                  final diff = _daysUntil(dateValue);
                  final isPast = diff < 0;
                  final courseIdStr = (ev['courseId'] ?? '').toString();
                  final cName =
                      professorCourses.firstWhere(
                        (c) => c['id'] == courseIdStr,
                        orElse: () => {'name': courseIdStr},
                      )['name'];

                  return Opacity(
                    opacity: isPast ? 0.6 : 1.0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderMedium),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dateValue.day.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.0,
                                  ),
                                ),
                                Text(
                                  group.key
                                      .split(' ')[0]
                                      .substring(0, 3)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textSecondary,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (ev['title'] ?? '').toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          _deleteEvent(ev['id'].toString()),
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          LucideIcons.trash2,
                                          size: 14,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          LucideIcons.bookOpen,
                                          size: 10,
                                          color: AppColors.textTertiary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          (cName ?? '').toString(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((ev['time'] ?? '').toString().isNotEmpty)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.clock,
                                            size: 10,
                                            color: AppColors.textTertiary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            (ev['time'] ?? '').toString(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: style['bg'] as Color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.tag,
                                            size: 8,
                                            color: style['color'] as Color,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            (style['label'] ?? '').toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: style['color'] as Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPast
                                            ? AppColors.background
                                            : AppColors.primarySurface,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        _daysUntilLabel(diff),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isPast
                                              ? AppColors.textSecondary
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if ((ev['notes'] ?? '').toString().isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      (ev['notes'] ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _filterBtn(String value, String label) {
    final isSelected = _filter == value;
    return Padding(
      padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: ElevatedButton(
        onPressed: () => setState(() => _filter = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
          foregroundColor: isSelected ? Colors.white : AppColors.textSecondary,
          elevation: 0,
          side: isSelected ? null : BorderSide(color: AppColors.borderMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
