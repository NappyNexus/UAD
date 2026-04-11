import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/student_model.dart';
import '../../data/models/payment_model.dart';

class PdfService {
  /// Generates a summary report PDF for the Administration.
  static Future<void> generateAdminReport({
    required String title,
    required List<dynamic> enrollmentTrend,
    required List<dynamic> studentsByProgram,
    required List<dynamic> statusBreakdown,
  }) async {
    final pdf = pw.Document();

    // Load assets if needed (e.g. logos), for now using basic widgets
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'UNIVERSIDAD ADVENTISTA DOMINICANA',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green900,
                      ),
                    ),
                    pw.Text('Sistema de Gestión Académica (UniPortal ADU)'),
                    pw.Text('Reporte Estadístico Consolidado'),
                  ],
                ),
                pw.Text(
                  DateTime.now().toString().split(' ')[0],
                  style: const pw.TextStyle(color: PdfColors.grey),
                ),
              ],
            ),
            pw.Divider(thickness: 1, color: PdfColors.grey300),
            pw.SizedBox(height: 20),

            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // KPIs Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildKpi('Estudiantes', '1,463'),
                _buildKpi('Índice Prom.', '3.18'),
                _buildKpi('Recaudado', 'RD\$45.2M'),
                _buildKpi('Aprobación', '87.3%'),
              ],
            ),
            pw.SizedBox(height: 30),

            // Enrollment Trend Table
            pw.Text(
              'Tendencia de Matrícula',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['Período', 'Estudiantes'],
              data: enrollmentTrend
                  .map((e) => [e['period'], e['students']])
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.green800,
              ),
              cellAlignment: pw.Alignment.center,
            ),
            pw.SizedBox(height: 30),

            // Students by Program Table
            pw.Text(
              'Distribución por Programa',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['Programa', 'Cantidad de Estudiantes'],
              data: studentsByProgram
                  .map((p) => [p['name'], p['value']])
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.green800,
              ),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 30),

            // Status Breakdown
            pw.Text(
              'Estado del Alumnado',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['Estado', 'Estudiantes'],
              data: statusBreakdown
                  .map((s) => [s['name'], s['value']])
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.green800,
              ),
              cellAlignment: pw.Alignment.center,
            ),

            pw.SizedBox(height: 40),
            pw.Center(
              child: pw.Text(
                'Propiedad de la Universidad Adventista Dominicana - Confidencial',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Reporte_UNAD_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  /// Generates a student's academic record (Kardex) PDF.
  static Future<void> generateAcademicRecord({
    required StudentModel student,
    required Map<String, List<dynamic>> semesters,
    required int totalCredits,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'UNIVERSIDAD ADVENTISTA DOMINICANA',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green900,
                      ),
                    ),
                    pw.Text('Récord Académico de Calificaciones (Kardex)'),
                    pw.Text('Oficina de Registro Académico'),
                  ],
                ),
                pw.Text(
                  DateTime.now().toString().split(' ')[0],
                  style: const pw.TextStyle(color: PdfColors.grey),
                ),
              ],
            ),
            pw.Divider(thickness: 1, color: PdfColors.grey300),
            pw.SizedBox(height: 20),

            // Student Summary Card
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'EstStatus: ${student.name}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      pw.Text('ID: ${student.id}'),
                      pw.Text('Cédula: ${student.cedula}'),
                    ],
                  ),
                  pw.SizedBox(width: 40),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Programa: ${student.program}'),
                      pw.Text('Estado: ${student.status}'),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Índice Gral.: ${(student.gpa / 4.0 * 100).toStringAsFixed(1)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('Créditos Aprob.: $totalCredits'),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Semesters
            ...semesters.entries.map((entry) {
              final courses = entry.value;
              final semCredits = courses.fold<int>(
                0,
                (a, c) => a + (c.credits as int),
              );
              final avgGrade =
                  courses.fold<double>(0, (a, c) => a + (c.finalGrade ?? 0)) /
                  courses.length;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.green50,
                    ),
                    width: double.infinity,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Período: ${entry.key}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green900,
                          ),
                        ),
                        pw.Text(
                          'Índice del Período: ${avgGrade.toStringAsFixed(0)}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.TableHelper.fromTextArray(
                    headers: [
                      'Código',
                      'Asignatura',
                      'Créditos',
                      'Calificación',
                    ],
                    data: courses
                        .map(
                          (c) => [
                            c.courseId,
                            c.courseName,
                            '${c.credits}',
                            '${(c.finalGrade ?? 0.0).toStringAsFixed(0)}',
                          ],
                        )
                        .toList(),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      fontSize: 10,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.green800,
                    ),
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    cellAlignment: pw.Alignment.centerLeft,
                    columnWidths: {
                      0: const pw.FixedColumnWidth(80),
                      1: const pw.FlexColumnWidth(),
                      2: const pw.FixedColumnWidth(60),
                      3: const pw.FixedColumnWidth(80),
                    },
                  ),
                  pw.SizedBox(height: 8),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Créditos en el período: $semCredits',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                ],
              );
            }),

            pw.SizedBox(height: 40),
            pw.Divider(thickness: 0.5, color: PdfColors.grey),
            pw.Center(
              child: pw.Text(
                'Documento oficial generado electrónicamente por UniPortal ADU. No requiere firma física.',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Kardex_${student.id}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  /// Generates a payment receipt (Invoice) PDF.
  static Future<void> generatePaymentReceipt({
    required StudentModel student,
    required PaymentModel payment,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'RECIBO DE PAGO',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green900,
                        ),
                      ),
                      pw.Text(
                        'UNAD - Oficinas Administrativas',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Text(
                    'No. ${payment.id}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.green800),
              pw.SizedBox(height: 20),

              // Student Info
              pw.Text(
                'PAGADO POR:',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                student.name,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Matrícula: ${student.id}'),
              pw.SizedBox(height: 16),

              // Payment Details
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Column(
                  children: [
                    _line('Concepto', payment.concept),
                    _line('Fecha', payment.date),
                    _line('Método', payment.method ?? 'Transferencia'),
                    pw.Divider(color: PdfColors.grey300),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'TOTAL PAGADO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'RD\$ ${payment.amount.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                            color: PdfColors.green900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),
              pw.Center(
                child: pw.Text(
                  'Gracias por su pago.',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Documento No Oficial / Simulación',
                  style: const pw.TextStyle(
                    fontSize: 6,
                    color: PdfColors.grey400,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Recibo_${payment.id}.pdf',
    );
  }

  /// Generates an institutional certificate PDF.
  static Future<void> generateCertificate({
    required StudentModel student,
    required String type,
    required String certId,
    required String date,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(50),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(2),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green900, width: 4),
            ),
            child: pw.Container(
              padding: const pw.EdgeInsets.all(30),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.green800, width: 1),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'UNIVERSIDAD ADVENTISTA DOMINICANA',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Oficina de Registro Académico',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    'CERTIFICACIÓN DE ${type.toUpperCase()}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.SizedBox(height: 50),
                  pw.Text(
                    'A QUIEN PUEDA INTERESAR:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Por medio de la presente, la UNIVERSIDAD ADVENTISTA DOMINICANA certifica que el estudiante:',
                    textAlign: pw.TextAlign.justify,
                  ),
                  pw.SizedBox(height: 15),
                  pw.Center(
                    child: pw.Text(
                      student.name,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Portador de la cédula No. ${student.cedula} y matrícula académica No. ${student.id}, es un estudiante regular inscrito con el estatus de ${student.status} en el programa de:',
                    textAlign: pw.TextAlign.justify,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      student.program,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'Dada en el municipio de Sonador, Bonao, el día $date.',
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Spacer(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        children: [
                          pw.SizedBox(
                            width: 150,
                            child: pw.Divider(
                              thickness: 1,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            'Reg. Académico',
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.SizedBox(
                            width: 150,
                            child: pw.Divider(
                              thickness: 1,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            'Secretaria General',
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Ref: $certId',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Certificado_${student.id}.pdf',
    );
  }

  static pw.Widget _line(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildKpi(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Helper to build the institutional header
  static pw.Widget _buildHeader(String documentType) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'UNIVERSIDAD ADVENTISTA DOMINICANA',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green900,
              ),
            ),
            pw.Text('Sistema de Gestión Académica (UniPortal ADU)'),
            pw.Text(documentType),
          ],
        ),
        pw.Text(
          DateTime.now().toString().split(' ')[0],
          style: const pw.TextStyle(color: PdfColors.grey),
        ),
      ],
    );
  }

  /// Generates a report for Enrollment Trend.
  static Future<void> generateEnrollmentTrendReport(List<dynamic> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Reporte de Tendencia de Matrícula'),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Text(
                'Tendencia Histórica de Inscripción',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Período', 'Estudiantes Inscritos'],
                data: data.map((e) => [e['period'], e['students']]).toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green800,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.center,
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Tendencia_Matricula.pdf',
    );
  }

  /// Generates a report for Program Distribution.
  static Future<void> generateProgramDistributionReport(
    List<dynamic> data,
  ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Reporte de Estudiantes por Programa'),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Text(
                'Distribución de Alumnado por Carrera',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Programa Académico', 'Total Estudiantes'],
                data: data.map((e) => [e['name'], e['value']]).toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green800,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Distribucion_Programas.pdf',
    );
  }

  /// Generates a report for Tuition Collection status.
  static Future<void> generateTuitionCollectionReport(
    List<dynamic> data,
  ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Reporte de Cobranza de Matrícula'),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Text(
                'Estado de Recaudación y Pendientes',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Mes', 'Cobrado (RD\$)', 'Pendiente (RD\$)'],
                data: data
                    .map(
                      (e) => [
                        e['month'],
                        'RD\$ ${((e['cobrado'] as int) / 1000).toStringAsFixed(0)}K',
                        'RD\$ ${((e['pendiente'] as int) / 1000).toStringAsFixed(0)}K',
                      ],
                    )
                    .toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green800,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.centerRight,
                columnWidths: {0: const pw.FixedColumnWidth(100)},
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Cobranza_Matricula.pdf',
    );
  }

  /// Generates a report for GPA Distribution.
  static Future<void> generateGpaDistributionReport(List<dynamic> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Reporte de Distribución de Índices (GPA)'),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Text(
                'Análisis del Rendimiento Académico',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Rango de Índice', 'Cantidad de Estudiantes'],
                data: data.map((e) => [e['range'], e['count']]).toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green800,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.center,
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Distribucion_GPA.pdf',
    );
  }

  /// Generates a report for Status Breakdown.
  static Future<void> generateStatusBreakdownReport(List<dynamic> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Reporte de Estado del Alumnado'),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Text(
                'Distribución por Estatus Académico',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Estado', 'Total Estudiantes'],
                data: data.map((e) => [e['name'], e['value']]).toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green800,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Estado_Alumnado.pdf',
    );
  }
}
