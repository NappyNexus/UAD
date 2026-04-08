import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/status_badge.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _tab = 'payments';

  @override
  Widget build(BuildContext context) {
    final s = currentStudent;
    final paid = accountStatement
        .where((p) => p.status == 'Pagado')
        .fold<double>(0, (a, b) => a + b.amount);
    final pending = accountStatement
        .where((p) => p.status == 'Pendiente')
        .fold<double>(0, (a, b) => a + b.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Pagos y Finanzas',
            subtitle: 'Gestiona tus pagos y consulta tu estado de cuenta',
          ),

          // ═══ Stats ═══
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: LucideIcons.dollarSign,
                  iconColor: AppColors.error,
                  iconBgColor: AppColors.errorSurface,
                  label: 'Balance',
                  value: Formatters.currencyShort(s.balance),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: LucideIcons.creditCard,
                  iconColor: AppColors.success,
                  iconBgColor: AppColors.successSurface,
                  label: 'Pagado',
                  value: Formatters.currencyShort(paid),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StatCard(
            icon: LucideIcons.receipt,
            iconColor: AppColors.goldDark,
            iconBgColor: AppColors.goldSurface,
            label: 'Pendiente',
            value: Formatters.currencyShort(pending),
          ),
          const SizedBox(height: 16),

          // ═══ Pay Button ═══
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showPaymentModal(context),
              icon: const Icon(LucideIcons.creditCard, size: 18),
              label: const Text(
                'Realizar Pago',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ═══ Tabs ═══
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _tabButton('payments', 'Pagos'),
                _tabButton('statement', 'Estado de Cuenta'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ═══ Tab Content ═══
          if (_tab == 'payments')
            ...accountStatement.map(
              (p) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.concept,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${Formatters.dateShort(p.date)}${p.method != null ? ' · ${p.method}' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.currencyShort(p.amount),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatusBadge(status: p.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          if (_tab == 'statement')
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historial de Transacciones',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.download, size: 14),
                      label: const Text('PDF', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...accountStatement.map(
                  (p) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: p.isPaid
                                ? AppColors.successSurface
                                : AppColors.errorSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            p.isPaid
                                ? LucideIcons.checkCircle
                                : LucideIcons.clock,
                            size: 18,
                            color: p.isPaid
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.concept,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.dateShort(p.date),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.currencyShort(p.amount),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: p.isPaid
                                    ? AppColors.textPrimary
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(height: 6),
                            StatusBadge(status: p.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tabButton(String key, String label) {
    final isActive = _tab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentModalContent(),
    );
  }
}

class PaymentModalContent extends StatefulWidget {
  const PaymentModalContent({super.key});

  @override
  State<PaymentModalContent> createState() => _PaymentModalContentState();
}

class _PaymentModalContentState extends State<PaymentModalContent> {
  String _selectedConcept = 'Cuota 3/4 - Colegiatura (RD\$12,500)';
  final TextEditingController _montoController = TextEditingController(
    text: 'RD\$12,500.00',
  );
  final TextEditingController _customConceptController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedMethod = 'Transferencia';
  String? _selectedBank;
  String? _selectedCard;
  bool _obscureCVV = true;
  bool _isAddingNewCard = false;
  bool _saveCard = true;

  final List<String> _concepts = [
    'Cuota 3/4 - Colegiatura (RD\$12,500)',
    'Cuota 4/4 - Colegiatura (RD\$12,500)',
    'Monto Personalizado',
  ];

  final List<String> _banks = [
    'Banco Popular Dominicano',
    'Banreservas',
    'Banco BHD',
    'Asociación Popular de Ahorros y Préstamos',
    'Scotiabank',
    'Banco Santa Cruz',
    'Banco Promerica',
  ];

  @override
  void dispose() {
    _montoController.dispose();
    _customConceptController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onConceptChanged(String? val) {
    if (val == null) return;
    setState(() {
      _selectedConcept = val;
      if (val == 'Cuota 3/4 - Colegiatura (RD\$12,500)' ||
          val == 'Cuota 4/4 - Colegiatura (RD\$12,500)') {
        _montoController.text = 'RD\$12,500.00';
      } else {
        _montoController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Realizar Pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        LucideIcons.x,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('CONCEPTO'),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderMedium),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedConcept,
                          isExpanded: true,
                          icon: const Icon(
                            LucideIcons.chevronDown,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          items: _concepts.map((String c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onConceptChanged,
                        ),
                      ),
                    ),
                    if (_selectedConcept == 'Monto Personalizado') ...[
                      const SizedBox(height: 16),
                      _buildLabel('DESCRIPCIÓN DEL CONCEPTO'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        'Ej: Pago de certificación o mora',
                        controller: _customConceptController,
                      ),
                    ],
                    const SizedBox(height: 16),

                    _buildLabel('MONTO'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _montoController,
                      readOnly: _selectedConcept != 'Monto Personalizado',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.borderMedium,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('MÉTODO DE PAGO'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _methodChip(
                          'Transferencia',
                          _selectedMethod == 'Transferencia',
                        ),
                        const SizedBox(width: 8),
                        _methodChip('Tarjeta', _selectedMethod == 'Tarjeta'),
                        const SizedBox(width: 8),
                        _methodChip(
                          'Ventanilla',
                          _selectedMethod == 'Ventanilla',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_selectedMethod == 'Transferencia')
                      _buildTransferenciaSection(),
                    if (_selectedMethod == 'Tarjeta') _buildTarjetaSection(),
                    if (_selectedMethod == 'Ventanilla')
                      _buildVentanillaSection(),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1B704C,
                          ), // Assuming AppColors.primary is this green
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirmar Pago',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 1.0,
    ),
  );

  Widget _methodChip(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1B704C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? const Color(0xFF1B704C) : AppColors.borderMedium,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransferenciaSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DATOS DE TRANSFERENCIA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F51E5),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('BANCO DE ORIGEN'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderMedium),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBank,
                hint: const Text(
                  'Seleccionar banco...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(LucideIcons.chevronDown, size: 18),
                items: _banks.map((String c) {
                  return DropdownMenuItem<String>(
                    value: c,
                    child: Text(
                      c,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBank = val),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildLabel('CÓDIGO / NÚMERO DE CONFIRMACIÓN'),
          const SizedBox(height: 6),
          _buildTextField('Ej: TRF-2024-789456'),
          const SizedBox(height: 12),

          _buildLabel('FECHA DE LA TRANSFERENCIA'),
          const SizedBox(height: 6),
          _buildTextField(
            'mm/dd/yyyy',
            icon: LucideIcons.calendar,
            controller: _dateController,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(
                  () => _dateController.text =
                      "\${date.month.toString().padLeft(2, '0')}/\${date.day.toString().padLeft(2, '0')}/\${date.year}",
                );
              }
            },
          ),
          const SizedBox(height: 12),

          _buildLabel('HORA DE LA TRANSFERENCIA'),
          const SizedBox(height: 6),
          _buildTextField(
            '--:-- --',
            icon: LucideIcons.clock,
            controller: _timeController,
            readOnly: true,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null && mounted) {
                setState(() => _timeController.text = time.format(context));
              }
            },
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCFE1FF)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuenta Destino UNAD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Banreservas · Cta. 000-123456-7',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'RNC: 4-01-12345-6',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'A nombre de: Universidad UNAD, S.A.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    IconData? icon,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        suffixIcon: icon != null
            ? Icon(icon, size: 16, color: AppColors.textPrimary)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildVentanillaSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instrucciones para pago en ventanilla',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Dirígete a la caja de la universidad en horario de 8am-4pm.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text:
                      '2. Presenta tu carnet estudiantil y menciona tu matrícula: ',
                ),
                TextSpan(
                  text: 'STU-2024-001',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '3. Realiza el pago del monto indicado. Se emitirá un recibo oficial.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '4. Entrega una copia del recibo al departamento de finanzas.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaSection() {
    if (_isAddingNewCard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('NUEVA TARJETA'),
              GestureDetector(
                onTap: () => setState(() => _isAddingNewCard = false),
                child: const Row(
                  children: [
                    Icon(
                      LucideIcons.arrowLeft,
                      size: 14,
                      color: Color(0xFF1B704C),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Volver',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B704C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLabel('NÚMERO DE TARJETA'),
          const SizedBox(height: 6),
          _buildTextField(
            '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
              LengthLimitingTextInputFormatter(19),
            ],
          ),
          const SizedBox(height: 12),
          _buildLabel('NOMBRE DEL TITULAR'),
          const SizedBox(height: 6),
          _buildTextField('Como aparece en la tarjeta'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('VENCIMIENTO'),
                    const SizedBox(height: 6),
                    _buildTextField('MM/AA'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('CVV'),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: _obscureCVV,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '...',
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscureCVV = !_obscureCVV),
                          child: Icon(
                            _obscureCVV ? LucideIcons.eye : LucideIcons.eyeOff,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.borderMedium,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _saveCard = !_saveCard),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _saveCard ? const Color(0xFF1B704C) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _saveCard
                          ? const Color(0xFF1B704C)
                          : AppColors.borderMedium,
                    ),
                  ),
                  child: _saveCard
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Guardar tarjeta para futuros pagos',
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('TARJETAS GUARDADAS'),
        const SizedBox(height: 8),
        _buildCardItem(
          'Visa',
          '4532',
          '08/27',
          'MARIA E RODRIGUEZ',
          Colors.blue.shade700,
        ),
        const SizedBox(height: 12),
        _buildCardItem(
          'Mastercard',
          '8821',
          '03/26',
          'MARIA E RODRIGUEZ',
          Colors.red.shade600,
        ),

        if (_selectedCard != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'CVV ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            obscureText: _obscureCVV,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: '...',
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureCVV = !_obscureCVV),
                child: Icon(
                  _obscureCVV ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderMedium),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _isAddingNewCard = true),
          child: const Row(
            children: [
              Icon(LucideIcons.plus, size: 16, color: Color(0xFF1B704C)),
              SizedBox(width: 6),
              Text(
                'Usar otra tarjeta',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B704C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem(
    String brand,
    String last4,
    String exp,
    String name,
    Color brandColor,
  ) {
    bool isSelected = _selectedCard == '$brand $last4';
    return GestureDetector(
      onTap: () => setState(() => _selectedCard = '$brand $last4'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1B704C)
                : AppColors.borderMedium,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1B704C)
                      : AppColors.borderMedium,
                  width: isSelected ? 5 : 1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      brand,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: brandColor,
                      ),
                    ),
                    const Text(
                      ' •••• ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      last4,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Vence $exp · $name',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) return newValue;

    String text = newValue.text.replaceAll(' ', '');
    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        formatted += ' ';
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: 'RD\$0',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    double value = double.parse(digits);
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'RD\$',
      decimalDigits: 0,
    );
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
