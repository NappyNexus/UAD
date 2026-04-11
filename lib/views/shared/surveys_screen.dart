import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';

class SurveysScreen extends StatefulWidget {
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
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

class _SurveysScreenState extends State<SurveysScreen> {
  final List<Map<String, dynamic>> _surveys = [
    {
      'id': 1,
      'title': 'Evaluación Docente - Cálculo III',
      'description':
          'Evalúa el desempeño de tu profesor durante el actual cuatrimestre.',
      'professor': 'Dr. Carlos Martínez',
      'course': 'MAT-301',
      'type': 'course',
      'status': 'pending',
      'questions': 8,
      'deadline': '25 Oct, 2024',
    },
    {
      'id': 2,
      'title': 'Encuesta Satisfacción Estudiantil 2026',
      'description':
          'Encuesta general sobre los servicios de la universidad (biblioteca, cafetería, etc).',
      'type': 'general',
      'status': 'pending',
      'questions': 15,
      'deadline': '30 Nov, 2024',
    },
    {
      'id': 3,
      'title': 'Evaluación Docente - Ética Profesional',
      'description':
          'Evalúa el desempeño de tu profesor durante el actual cuatrimestre.',
      'professor': 'Lic. Carmen Sosa',
      'course': 'HUM-200',
      'type': 'course',
      'status': 'completed',
      'questions': 8,
      'deadline': '10 Oct, 2024',
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

    final isProfessor =
        true; // Mocked for demonstration since we are in Professor Portal context

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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Encuestas',
            subtitle: 'Tu opinión ayuda a mejorar UNAD',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Pendientes',
                  value: pending.length.toString(),
                  icon: LucideIcons.clock,
                  iconColor: Colors.amber.shade600,
                  bgColor: Colors.amber.shade50,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Completadas',
                  value: completed.length.toString(),
                  icon: LucideIcons.checkCircle,
                  iconColor: Colors.green.shade600,
                  bgColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Tasa resp.',
                  value: '$responseRate%',
                  icon: LucideIcons.trendingUp,
                  iconColor: Colors.blue.shade600,
                  bgColor: Colors.blue.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (pending.isNotEmpty) ...[
            Row(
              children: [
                Icon(LucideIcons.clock, size: 14, color: Colors.amber.shade500),
                SizedBox(width: 8),
                Text(
                  'Pendientes (${pending.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pending.map(
              (s) => _SurveyPendingCard(s, onTap: () => showSurveyModal(s)),
            ),
            const SizedBox(height: 24),
          ],
          if (completed.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  LucideIcons.checkCircle,
                  size: 14,
                  color: Colors.green.shade500,
                ),
                SizedBox(width: 8),
                Text(
                  'Completadas (${completed.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCourse
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                isCourse ? LucideIcons.star : LucideIcons.barChart3,
                size: 18,
                color: isCourse ? AppColors.primary : Colors.blue.shade600,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  survey['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                if (survey['professor'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      survey['professor'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                SizedBox(height: 4),
                Text(
                  survey['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.messageSquare,
                          size: 10,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${survey['questions']} preguntas',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 10,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vence: ${survey['deadline']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.amber.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Iniciar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 4),
                Icon(LucideIcons.chevronRight, size: 14),
              ],
            ),
          ),
        ],
      ),
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
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.checkCircle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text(
                '¡Evaluación enviada!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Gracias por tu aporte.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderMedium)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.survey['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.survey['professor'] != null) ...[
                        SizedBox(height: 4),
                        Text(
                          widget.survey['professor'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(
                20,
              ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              itemCount: _courseQuestions.length,
              separatorBuilder: (_, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(height: 1, color: AppColors.borderMedium),
              ),
              itemBuilder: (ctx, i) {
                final q = _courseQuestions[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q['text'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (q['type'] == 'rating')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          final value = index + 1;
                          final isSelected = (_answers[q['id']] ?? 0) >= value;
                          return InkWell(
                            onTap: () =>
                                setState(() => _answers[q['id']] = value),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                LucideIcons.star,
                                size: 32,
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                              ),
                            ),
                          );
                        }),
                      ),
                    if (q['type'] == 'rating')
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Muy malo',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Excelente',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (q['type'] == 'yesno')
                      Row(
                        children: ['Sí', 'No'].map((opt) {
                          final selected = _answers[q['id']] == opt;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _answers[q['id']] = opt),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.borderMedium,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  opt,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    if (q['type'] == 'text')
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          maxLines: 3,
                          onChanged: (v) =>
                              setState(() => _answers[q['id']] = v),
                          decoration: InputDecoration(
                            hintText: 'Escribe tu respuesta aquí...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderMedium)),
            ),
            child: SizedBox(
              width: double.infinity,
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Enviar Evaluación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
