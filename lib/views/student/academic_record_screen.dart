import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/student_model.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';

class AcademicRecordScreen extends StatelessWidget {
  const AcademicRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = currentStudent;
    final allCourses = gradeHistory;
    final totalCredits = allCourses.fold<int>(0, (a, c) => a + c.credits);
    final semesters = <String, List<dynamic>>{};
    for (final g in allCourses) {
      semesters.putIfAbsent(g.semester, () => []).add(g);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Récord Académico (Kardex)',
            subtitle: 'Historial completo de calificaciones',
            action: ElevatedButton.icon(
              onPressed: () => _generatePdf(context, s, semesters, totalCredits),
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ═══ Student Info Card ═══
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: s.photo != null
                        ? Image.network(s.photo!, fit: BoxFit.cover)
                        : Container(
                            color: AppColors.primarySurface,
                            child: Center(
                              child: Text(
                                s.name[0],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  s.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  s.program,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${s.id} · Cohorte: ${s.cohort} · Estado: ${s.status}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.6,
                  children: [
                    StatCard(
                      icon: LucideIcons.trendingUp,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primarySurface,
                      label: 'Índice General',
                      value: (s.gpa / 4.0 * 100).toStringAsFixed(1),
                    ),
                    StatCard(
                      icon: LucideIcons.bookOpen,
                      iconColor: AppColors.info,
                      iconBgColor: AppColors.infoSurface,
                      label: 'Créditos Aprob.',
                      value: '$totalCredits',
                    ),
                    StatCard(
                      icon: LucideIcons.award,
                      iconColor: AppColors.goldDark,
                      iconBgColor: AppColors.goldSurface,
                      label: 'Materias',
                      value: '${allCourses.length}',
                    ),
                    StatCard(
                      icon: LucideIcons.fileText,
                      iconColor: const Color(0xFF7C3AED),
                      iconBgColor: const Color(0xFFF5F3FF),
                      label: 'Semestres',
                      value: '${semesters.length}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ═══ Record per Semester ═══
          ...semesters.entries.map((entry) {
            final semName = entry.key;
            final courses = entry.value;
            final semCredits = courses.fold<int>(
              0,
              (a, c) => a + (c.credits as int),
            );
            final avgGrade =
                courses.fold<double>(0, (a, c) => a + (c.finalGrade ?? 0)) /
                courses.length;

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Período $semName',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Índice: ${avgGrade.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mobile-friendly List
                  Column(
                    children: courses.map((c) {
                      final grade = c.finalGrade ?? 0.0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${c.credits}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.0),
                                  ),
                                  Text(
                                    'CR',
                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textTertiary),
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
                                    c.courseName,
                                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    c.courseId,
                                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: grade >= 90 ? AppColors.successSurface : grade >= 70 ? AppColors.infoSurface : AppColors.errorSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${grade.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: grade >= 90 ? AppColors.success : grade >= 70 ? AppColors.info : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  // Footer
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total del Período',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '$semCredits créditos · Índice ${avgGrade.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _generatePdf(
    BuildContext context,
    StudentModel s,
    Map<String, List<dynamic>> semesters,
    int totalCredits,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Récord Académico', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text('UNAD', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Estudiante: ${s.name}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('Matrícula: ${s.id}'),
                  pw.Text('Programa: ${s.program}'),
                  pw.Text('Estado: ${s.status}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Índice General: ${(s.gpa / 4.0 * 100).toStringAsFixed(1)} | Créditos Aprobados: $totalCredits'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            ...semesters.entries.map((entry) {
              final courses = entry.value;
              final semCredits = courses.fold<int>(0, (a, c) => a + (c.credits as int));
              final avgGrade = courses.fold<double>(0, (a, c) => a + (c.finalGrade ?? 0)) / courses.length;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Período ${entry.key}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.TableHelper.fromTextArray(
                    headers: ['Código', 'Materia', 'Créditos', 'Nota'],
                    data: courses.map((c) => [
                      c.courseId,
                      c.courseName,
                      '${c.credits}',
                      '${(c.finalGrade ?? 0.0).toStringAsFixed(0)}',
                    ]).toList(),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                    headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                    rowDecoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                    ),
                    cellAlignment: pw.Alignment.centerLeft,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Total Período: $semCredits créditos | Índice: ${avgGrade.toStringAsFixed(0)}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 20),
                ],
              );
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Record_Academico_${s.id}.pdf',
    );
  }
}
