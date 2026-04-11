import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/state/professor_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/common/page_header.dart';

class CourseAnnouncementsScreen extends ConsumerStatefulWidget {
  const CourseAnnouncementsScreen({super.key});

  @override
  ConsumerState<CourseAnnouncementsScreen> createState() =>
      _CourseAnnouncementsScreenState();
}

class _CourseAnnouncementsScreenState
    extends ConsumerState<CourseAnnouncementsScreen> {
  String _filter = 'all';
  bool _composing = false;

  String _newCourseId = professorCourses.isNotEmpty
      ? (professorCourses[0]['id'] ?? '').toString()
      : '';
  String _newType = 'general';
  String _newTitle = '';
  String _newBody = '';
  bool _newPinned = false;

  void _handlePost() {
    if (_newTitle.trim().isEmpty || _newBody.trim().isEmpty) return;
    final courseName = professorCourses.firstWhere(
      (c) => c['id'] == _newCourseId,
      orElse: () => {'name': 'General'},
    )['name'];

    final newAnn = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'courseId': _newCourseId,
      'courseName': courseName,
      'title': _newTitle.trim(),
      'body': _newBody.trim(),
      'type': _newType,
      'pinned': _newPinned,
      'date':
          '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
    };
    ref.read(announcementsProvider.notifier).addAnnouncement(newAnn);

    setState(() {
      _newCourseId = professorCourses.isNotEmpty
          ? (professorCourses[0]['id'] ?? '').toString()
          : '';
      _newType = 'general';
      _newTitle = '';
      _newBody = '';
      _newPinned = false;
      _composing = false;
    });
  }

  void _togglePin(int id) {
    ref.read(announcementsProvider.notifier).togglePin(id);
  }

  void _deleteAnn(int id) {
    ref.read(announcementsProvider.notifier).deleteAnnouncement(id);
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'aviso':
        return AppColors.warning;
      case 'material':
        return AppColors.info;
      case 'entrega':
        return const Color(0xFFA855F7); // Purple
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getTypeBg(String type) {
    switch (type) {
      case 'aviso':
        return AppColors.warning.withValues(alpha: 0.1);
      case 'material':
        return AppColors.info.withValues(alpha: 0.1);
      case 'entrega':
        return const Color(0xFFF3E8FF); // Purple bg
      default:
        return AppColors.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcements = ref.watch(announcementsProvider);
    final filtered = _filter == 'all'
        ? announcements
        : announcements.where((a) => a['courseId'] == _filter).toList();
    filtered.sort((a, b) {
      final pA = a['pinned'] as bool;
      final pB = b['pinned'] as bool;
      if (pA && !pB) return -1;
      if (!pA && pB) return 1;
      return (b['date'] as String).compareTo(a['date'] as String);
    });

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: PageHeader(
                  title: 'Comunicados',
                  subtitle: 'Anuncios para tus cursos',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _composing = !_composing),
                icon: const Icon(LucideIcons.megaphone, size: 14),
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

          if (_composing)
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
                    'Nuevo Comunicado',
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
                              initialValue: _newCourseId,
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
                              initialValue: _newType,
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
                              items: const [
                                DropdownMenuItem(
                                  value: 'general',
                                  child: Text(
                                    'General',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'aviso',
                                  child: Text(
                                    'Aviso',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'material',
                                  child: Text(
                                    'Material',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'entrega',
                                  child: Text(
                                    'Entrega',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
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
                      hintText: 'Título del comunicado...',
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
                  TextField(
                    onChanged: (v) => setState(() => _newBody = v),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Escribe el mensaje...',
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
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 12,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _newPinned,
                              onChanged: (v) =>
                                  setState(() => _newPinned = v ?? false),
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Fijar comunicado',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => _composing = false),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton.icon(
                            onPressed:
                                (_newTitle.trim().isEmpty ||
                                    _newBody.trim().isEmpty)
                                ? null
                                : _handlePost,
                            icon: const Icon(LucideIcons.send, size: 14),
                            label: const Text('Publicar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
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
          const SizedBox(height: 16),

          // List
          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No hay comunicados aún.',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            ),

          ...filtered.map((ann) {
            final isPinned = ann['pinned'] as bool;
            final type = ann['type'] as String;
            final courseName = professorCourses.firstWhere(
              (c) => c['id'] == ann['courseId'],
              orElse: () => {'name': ann['courseId']},
            )['name'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPinned
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isPinned
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.megaphone,
                      size: 16,
                      color: isPinned ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                ann['title'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _togglePin(ann['id'] as int),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  LucideIcons.pin,
                                  size: 14,
                                  color: isPinned
                                      ? AppColors.primary
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _deleteAnn(ann['id'] as int),
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
                                  courseName as String,
                                  style: TextStyle(
                                    fontSize: 11,
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
                                  color: AppColors.textTertiary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  ann['date'] as String,
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
                                color: _getTypeBg(type),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getTypeColor(type),
                                ),
                              ),
                            ),
                            if (isPinned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '📌 Fijado',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          ann['body'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
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
