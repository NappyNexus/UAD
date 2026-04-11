import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/common/page_header.dart';

class SurveysScreen extends ConsumerStatefulWidget {
  const SurveysScreen({super.key});

  @override
  ConsumerState<SurveysScreen> createState() => _SurveysScreenState();
}

final List<Map<String, dynamic>> _courseQuestions = [
  {
    'id': 'q1',
    'text': '¿Cómo evaluarías la claridad en la explicación de los temas?',
    'type': 'rating',
  },
  {
    'id': 'q2',
    'text': '¿El profesor demuestra dominio del contenido del curso?',
    'type': 'rating',
  },
  {
    'id': 'q3',
    'text': '¿Cómo calificarías la puntualidad y asistencia del profesor?',
    'type': 'rating',
  },
  {
    'id': 'q4',
    'text': '¿El profesor responde dudas de manera efectiva?',
    'type': 'rating',
  },
  {
    'id': 'q5',
    'text': '¿Las evaluaciones reflejan el contenido enseñado?',
    'type': 'rating',
  },
  {
    'id': 'q6',
    'text': '¿Recomendarías este profesor a otros estudiantes?',
    'type': 'yesno',
  },
  {'id': 'q7', 'text': '¿Qué fue lo mejor del curso?', 'type': 'text'},
  {'id': 'q8', 'text': '¿Qué aspectos podrían mejorar?', 'type': 'text'},
];

class _SurveysScreenState extends ConsumerState<SurveysScreen> {
  void showSurveyModal(Map<String, dynamic> survey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SurveyModal(
        survey: survey,
        onSubmit: () {
          setState(() => survey['status'] = 'completed');
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _surveys = [
    {
      'id': 1,
      'title': 'Evaluación Docente - Cálculo III',
      'description':
          'Evalúa la calidad de la enseñanza, metodología y atención del profesor.',
      'professor': 'Dr. Carlos Martínez',
      'course': 'MAT-301',
      'type': 'course',
      'status': 'pending',
      'questions': 8,
      'deadline': '2026-04-15',
    },
    {
      'id': 2,
      'title': 'Evaluación Docente - Base de Datos II',
      'description':
          'Evalúa la calidad de la enseñanza, metodología y atención del profesor.',
      'professor': 'Ing. Ana Pérez',
      'course': 'ING-305',
      'type': 'course',
      'status': 'pending',
      'questions': 8,
      'deadline': '2026-04-15',
    },
    {
      'id': 3,
      'title': 'Encuesta Satisfacción Estudiantil 2026',
      'description':
          'Evaluación semestral sobre la experiencia general en la universidad, servicios y facilidades.',
      'type': 'general',
      'status': 'pending',
      'questions': 15,
      'deadline': '2026-04-30',
    },
    {
      'id': 4,
      'title': 'Evaluación Docente - Ética Profesional',
      'description':
          'Evalúa la calidad de la enseñanza, metodología y atención del profesor.',
      'professor': 'Lic. Carmen Sosa',
      'course': 'HUM-200',
      'type': 'course',
      'status': 'completed',
      'questions': 8,
      'deadline': '2026-03-01',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pending = _surveys.where((s) => s['status'] == 'pending').toList();
    final completed = _surveys
        .where((s) => s['status'] == 'completed')
        .toList();
    final responseRate = _surveys.isEmpty
        ? 0
        : (completed.length / _surveys.length * 100).round();

    final auth = ref.watch(authProvider);
    final isProfessor = auth.currentRole == AppConstants.roleTeacher;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isProfessor
          ? _buildProfessorView()
          : _buildStudentView(pending, completed, responseRate),
    );
  }

  Widget _buildStudentView(
    List<Map<String, dynamic>> pending,
    List<Map<String, dynamic>> completed,
    int responseRate,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encuestas y Evaluaciones',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tu opinión ayuda a mejorar la calidad académica',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats - Match React grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Pendientes',
                  value: pending.length.toString(),
                  icon: LucideIcons.clock,
                  iconColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Completadas',
                  value: completed.length.toString(),
                  icon: LucideIcons.checkCircle2,
                  iconColor: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Tasa resp.',
                  value: '$responseRate%',
                  icon: LucideIcons.trendingUp,
                  iconColor: const Color(0xFF2563EB),
                  bgColor: const Color(0xFFDBEAFE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          if (pending.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  LucideIcons.clock,
                  size: 16,
                  color: const Color(0xFFD97706),
                ),
                const SizedBox(width: 8),
                Text(
                  'PENDIENTES (${pending.length})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...pending.map(
              (s) => _SurveyPendingCard(s, onTap: () => showSurveyModal(s)),
            ),
            const SizedBox(height: 32),
          ],

          if (completed.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  LucideIcons.checkCircle2,
                  size: 16,
                  color: const Color(0xFF059669),
                ),
                const SizedBox(width: 8),
                Text(
                  'COMPLETADAS (${completed.length})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...completed.map((s) => _SurveyCompletedCard(s)),
          ],
        ],
      ),
    );
  }

  Widget _buildProfessorView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Resultados de Evaluación',
            subtitle: 'Reporte consolidado de retroalimentación estudiantil',
          ),
          const SizedBox(height: 16),

          // Stats Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Puntaje General',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '4.8 / 5.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            LucideIcons.trendingUp,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+0.3 vs cuat. ant.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _miniStat('85%', 'Tasa Respuesta'),
                    _miniStat('42', 'Estudiantes'),
                    _miniStat('Top 5%', 'Ranking Depto.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'DETALLE POR CRITERIO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _ratingRow('Dominio del tema', 4.9),
                _ratingRow('Claridad explicativa', 4.7),
                _ratingRow('Puntualidad', 4.8),
                _ratingRow('Efectividad en dudas', 4.9),
                _ratingRow('Calidad de materiales', 4.6),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'COMENTARIOS RECIENTES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          _commentCard(
            'Excelente profesor, explica muy bien y siempre está dispuesto a ayudar.',
          ),
          _commentCard(
            'Las clases son muy dinámicas, aunque el material de apoyo podría ser más extenso.',
          ),
          _commentCard(
            'Un gran dominio de la materia, hace que los temas difíciles parezcan fáciles.',
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String val, String label) => Column(
    children: [
      Text(
        val,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
    ],
  );

  Widget _ratingRow(String label, double val) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text(
              val.toString(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: val / 5.0,
          backgroundColor: AppColors.background,
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ],
    ),
  );

  Widget _commentCard(String text) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      '"$text"',
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontStyle: FontStyle.italic,
      ),
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color iconColor, bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SurveyPendingCard extends StatelessWidget {
  final Map<String, dynamic> survey;
  final VoidCallback onTap;

  const _SurveyPendingCard(this.survey, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCourse = survey['type'] == 'course';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isCourse
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(
                        isCourse ? LucideIcons.star : LucideIcons.barChart3,
                        size: 20,
                        color: isCourse
                            ? AppColors.primary
                            : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          survey['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        if (survey['professor'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              survey['professor'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          survey['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _SurveyInfoTag(
                              icon: LucideIcons.messageSquare,
                              label: '${survey['questions']} preguntas',
                            ),
                            _SurveyInfoTag(
                              icon: LucideIcons.clock,
                              label: 'Vence: ${survey['deadline']}',
                              color: const Color(0xFFD97706),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurveyInfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _SurveyInfoTag({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: effectiveColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: effectiveColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SurveyCompletedCard extends StatelessWidget {
  final Map<String, dynamic> survey;

  const _SurveyCompletedCard(this.survey);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.checkCircle, size: 18, color: Colors.green.shade500),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  survey['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (survey['professor'] != null)
                  Text(
                    survey['professor'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Completada',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyModal extends StatefulWidget {
  final Map<String, dynamic> survey;
  final VoidCallback onSubmit;

  const _SurveyModal({required this.survey, required this.onSubmit});

  @override
  State<_SurveyModal> createState() => _SurveyModalState();
}

class _SurveyModalState extends State<_SurveyModal> {
  final Map<String, dynamic> _answers = {};
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Container(
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  color: Color(0xFF059669),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Gracias por tu evaluación!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Tu retroalimentación ayuda a mejorar la calidad académica de UNAD.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final answeredCount = _answers.keys
        .where((k) => _answers[k] != null)
        .length;
    final totalCount = _courseQuestions.length;
    final double progress = totalCount > 0 ? answeredCount / totalCount : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.survey['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.survey['professor'] != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${widget.survey['professor']} · ${widget.survey['course']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar - Match React
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$answeredCount de $totalCount preguntas respondidas',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.background,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Questions
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(
                24,
              ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
              itemCount: _courseQuestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 32),
              itemBuilder: (ctx, i) {
                final q = _courseQuestions[i];
                return _SurveyQuestion(
                  index: i + 1,
                  question: q,
                  value: _answers[q['id']],
                  onChanged: (v) => setState(() => _answers[q['id']] = v),
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            child: ElevatedButton(
              onPressed: () {
                setState(() => _submitted = true);
                Future.delayed(const Duration(seconds: 2), () {
                  widget.onSubmit();
                  if (context.mounted) Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
              ),
              child: const Text(
                'Enviar Evaluación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyQuestion extends StatelessWidget {
  final int index;
  final Map<String, dynamic> question;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const _SurveyQuestion({
    required this.index,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$index. ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: question['text'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (question['type'] == 'rating')
          _StarRating(
            value: (value as num?)?.toInt() ?? 0,
            onChanged: onChanged,
          ),
        if (question['type'] == 'yesno')
          Row(
            children: ['Sí', 'No'].map((opt) {
              final selected = value == opt;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => onChanged(opt),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        if (question['type'] == 'text')
          TextField(
            maxLines: 4,
            onChanged: onChanged,
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Escribe tu respuesta aquí...',
              hintStyle: TextStyle(fontSize: 14, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _StarRating({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(5, (i) {
            final starValue = i + 1;
            final isHighlighted = starValue <= value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => onChanged(starValue),
                child: Icon(
                  LucideIcons.star,
                  size: 32,
                  color: isHighlighted
                      ? const Color(0xFFFBBF24)
                      : Colors.grey.shade300,
                  fill: isHighlighted ? 1.0 : 0.0,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Muy malo',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
            ),
            Text(
              'Excelente',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }
}
