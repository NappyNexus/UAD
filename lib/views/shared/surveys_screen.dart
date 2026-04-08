import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';

class SurveysScreen extends StatefulWidget {
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  final List<Map<String, dynamic>> _surveys = [
    {
      'id': 1,
      'title': 'Evaluación Docente - Cálculo III',
      'professor': 'Dr. Carlos Martínez',
      'course': 'MAT-301',
      'status': 'pending',
      'questions': 8,
    },
    {
      'id': 2,
      'title': 'Encuesta Satisfacción Estudiantil 2026',
      'status': 'pending',
      'questions': 15,
    },
    {
      'id': 3,
      'title': 'Evaluación Docente - Ética Profesional',
      'professor': 'Lic. Carmen Sosa',
      'course': 'HUM-200',
      'status': 'completed',
      'questions': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pending = _surveys.where((s) => s['status'] == 'pending').toList();
    final completed = _surveys
        .where((s) => s['status'] == 'completed')
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Encuestas',
              subtitle: 'Tu opinión ayuda a mejorar',
            ),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Pendientes',
                    value: pending.length.toString(),
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Completadas',
                    value: completed.length.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (pending.isNotEmpty) ...[
              const Text(
                'PENDIENTES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ...pending.map(
                (s) => _SurveyCard(
                  s,
                  isPending: true,
                  onTap: () {
                    setState(() => s['status'] = 'completed');
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (completed.isNotEmpty) ...[
              const Text(
                'COMPLETADAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ...completed.map((s) => _SurveyCard(s, isPending: false)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final Color color;
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final Map<String, dynamic> survey;
  final bool isPending;
  final VoidCallback? onTap;

  const _SurveyCard(this.survey, {required this.isPending, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPending ? 1.0 : 0.6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPending
                    ? AppColors.warningSurface
                    : AppColors.successSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPending ? LucideIcons.star : LucideIcons.checkCircle,
                color: isPending ? AppColors.warning : AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    survey['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (survey['professor'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        survey['professor'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${survey['questions']} preguntas',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isPending)
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Iniciar', style: TextStyle(fontSize: 12)),
              )
            else
              const Icon(LucideIcons.check, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}
