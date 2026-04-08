import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  final List<String> _months = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  ];
  final List<String> _days = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];

  int _year = 2026;
  int _month = 2; // March
  String _selectedDate = '2026-03-27';
  String _view = 'month';

  final List<Map<String, dynamic>> _events = [
    {
      'id': 1,
      'date': '2026-03-27',
      'title': 'Parcial 2 - Cálculo III',
      'type': 'exam',
      'time': '08:00',
      'location': 'Aula A-201',
      'course': 'MAT-301',
    },
    {
      'id': 2,
      'date': '2026-03-30',
      'title': 'Entrega Proyecto BD',
      'type': 'assignment',
      'time': '23:59',
      'location': 'Plataforma',
      'course': 'ING-305',
    },
    {
      'id': 3,
      'date': '2026-04-01',
      'title': 'Semana Santa - Asueto',
      'type': 'holiday',
    },
    {
      'id': 4,
      'date': '2026-04-05',
      'title': 'Fin Semana Santa',
      'type': 'holiday',
    },
    {
      'id': 5,
      'date': '2026-04-10',
      'title': 'Parcial 2 - Base de Datos II',
      'type': 'exam',
      'time': '10:00',
      'location': 'Lab-3',
      'course': 'ING-305',
    },
    {
      'id': 6,
      'date': '2026-04-15',
      'title': 'Plazo Evaluación Docente',
      'type': 'deadline',
      'time': '23:59',
    },
    {
      'id': 7,
      'date': '2026-04-18',
      'title': 'Charla: Inteligencia Artificial',
      'type': 'event',
      'time': '14:00',
      'location': 'Auditorio Central',
    },
    {
      'id': 8,
      'date': '2026-04-22',
      'title': 'Examen Final - Ética Profesional',
      'type': 'exam',
      'time': '08:00',
      'location': 'Aula B-301',
      'course': 'HUM-200',
    },
    {
      'id': 13,
      'date': '2026-03-27',
      'title': 'Clase de Redes de Computadoras',
      'type': 'class',
      'time': '14:00',
      'location': 'Lab-2',
      'course': 'ING-315',
    },
  ];

  final Map<String, Map<String, dynamic>> _typeConf = {
    'exam': {
      'label': 'Examen',
      'color': AppColors.error,
      'bg': AppColors.errorLight,
    },
    'assignment': {
      'label': 'Tarea',
      'color': AppColors.warning,
      'bg': AppColors.warningLight,
    },
    'holiday': {
      'label': 'Asueto',
      'color': Colors.purple,
      'bg': Colors.purple.shade50,
    },
    'deadline': {
      'label': 'Límite',
      'color': Colors.orange,
      'bg': Colors.orange.shade50,
    },
    'event': {
      'label': 'Evento',
      'color': AppColors.success,
      'bg': AppColors.successLight,
    },
    'class': {
      'label': 'Clase',
      'color': AppColors.info,
      'bg': AppColors.infoLight,
    },
  };

  void _prevMonth() => setState(() {
    if (_month == 0) {
      _year--;
      _month = 11;
    } else {
      _month--;
    }
  });

  void _nextMonth() => setState(() {
    if (_month == 11) {
      _year++;
      _month = 0;
    } else {
      _month++;
    }
  });

  List<Map<String, dynamic>> _getEventsForDate(String d) =>
      _events.where((e) => e['date'] == d).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysInMonth = DateTime(_year, _month + 2, 0).day;
    final firstDay = DateTime(_year, _month + 1, 1).weekday % 7;
    final upcomingEvents =
        _events.where((e) => e['date'].compareTo('2026-03-27') >= 0).toList()
          ..sort((a, b) => a['date'].compareTo(b['date']));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: PageHeader(
                    title: 'Calendario',
                    subtitle: 'Exámenes, entregas y eventos',
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderMedium),
                  ),
                  child: Row(
                    children: ['month', 'list']
                        .map(
                          (v) => InkWell(
                            onTap: () => setState(() => _view = v),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _view == v
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                v == 'month' ? 'Mes' : 'Lista',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _view == v
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Layout (stacking on mobile, we can just use columns)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: _view == 'month'
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.chevronLeft),
                                onPressed: _prevMonth,
                              ),
                              Text(
                                '${_months[_month]} $_year',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.chevronRight),
                                onPressed: _nextMonth,
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _days
                                .map(
                                  (d) => Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Divider(height: 1),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: firstDay + daysInMonth,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 0.8,
                              ),
                          itemBuilder: (ctx, i) {
                            if (i < firstDay) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: AppColors.borderMedium,
                                    ),
                                    bottom: BorderSide(
                                      color: AppColors.borderMedium,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final day = i - firstDay + 1;
                            final dateStr =
                                '$_year-${(_month + 1).toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
                            final today = dateStr == '2026-03-27';
                            final selected = dateStr == _selectedDate;
                            final evs = _getEventsForDate(dateStr);
                            return InkWell(
                              onTap: () =>
                                  setState(() => _selectedDate = dateStr),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primarySurface
                                      : null,
                                  border: Border(
                                    right: BorderSide(
                                      color: AppColors.borderMedium,
                                    ),
                                    bottom: BorderSide(
                                      color: AppColors.borderMedium,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: today ? AppColors.primary : null,
                                      ),
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: today
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    ...evs
                                        .take(2)
                                        .map(
                                          (e) => Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 2,
                                            ),
                                            height: 4,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  _typeConf[e['type']]!['color'],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingEvents.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final e = upcomingEvents[i];
                        final tc = _typeConf[e['type']]!;
                        return ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: tc['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e['title'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tc['bg'],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tc['label'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tc['color'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.calendar,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  e['date'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (e['time'] != null) ...[
                                  Icon(
                                    LucideIcons.clock,
                                    size: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    e['time'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDate == '2026-03-27' ? 'Hoy' : _selectedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._getEventsForDate(_selectedDate).map((e) {
                    final tc = _typeConf[e['type']]!;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tc['bg'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['title'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: tc['color'],
                            ),
                          ),
                          if (e['time'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${e['time']}${e['location'] != null ? ' · ${e['location']}' : ''}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: tc['color'],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  if (_getEventsForDate(_selectedDate).isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Sin eventos este día',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Leyenda Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leyenda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 16),
                  ..._typeConf.values.map((tc) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: tc['color'], shape: BoxShape.circle),
                        ),
                        SizedBox(width: 12),
                        Text(tc['label'], style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Sincronizar Calendario Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sincronizar calendario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  Text(
                    'Exporta tus eventos académicos a tu calendario personal',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  _buildSyncButton('Google Calendar', Colors.blue.shade700, Colors.blue.shade50),
                  const SizedBox(height: 12),
                  _buildSyncButton('Outlook Calendar', Colors.blue.shade700, Colors.blue.shade50),
                  const SizedBox(height: 12),
                  _buildSyncButton('Exportar .ics', AppColors.textSecondary, Colors.grey.shade50, AppColors.borderMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncButton(String text, Color color, Color bg, [Color? border]) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border ?? color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            Icon(LucideIcons.externalLink, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
