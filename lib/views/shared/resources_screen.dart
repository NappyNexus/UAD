import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _searchQuery = '';
  String _categoryFilter = 'all';
  bool _onlyStarred = false;

  final List<Map<String, dynamic>> _categories = [
    {'key': 'all', 'label': 'Todos'},
    {'key': 'book', 'label': 'Libros'},
    {'key': 'video', 'label': 'Videos'},
    {'key': 'article', 'label': 'Artículos'},
    {'key': 'tool', 'label': 'Herramientas'},
  ];

  final List<Map<String, dynamic>> _resources = [
    {
      'id': 1,
      'type': 'book',
      'title': 'Cálculo: Trascendentes Tempranas',
      'author': 'James Stewart',
      'course': 'Cálculo III',
      'description':
          'Libro de texto fundamental para el curso de Cálculo III. Incluye ejercicios resueltos.',
      'starred': true,
      'size': '45 MB',
    },
    {
      'id': 2,
      'type': 'video',
      'title': 'Integrales Dobles - Serie Completa',
      'author': 'Prof. Khan Academy',
      'course': 'Cálculo III',
      'description':
          'Serie de videos explicando integrales dobles desde conceptos básicos.',
      'starred': false,
      'duration': '3h 24min',
    },
    {
      'id': 3,
      'type': 'article',
      'title': 'Normalización en Base de Datos',
      'author': 'Dr. García López',
      'course': 'Base de Datos II',
      'description':
          'Artículo académico sobre formas normales con ejemplos prácticos.',
      'starred': true,
      'readTime': '15 min',
    },
    {
      'id': 4,
      'type': 'tool',
      'title': 'draw.io - Diagramas UML',
      'author': 'Diagrams.net',
      'course': 'Ingeniería de Software',
      'description':
          'Herramienta online para crear diagramas UML y flujos de procesos.',
      'starred': false,
      'free': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _resources.where((r) {
      final ms =
          r['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          r['author'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final mt = _categoryFilter == 'all' || r['type'] == _categoryFilter;
      final msf = !_onlyStarred || r['starred'] == true;
      return ms && mt && msf;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: 'Recursos', subtitle: 'Biblioteca digital'),

            // Filters
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(LucideIcons.search, size: 18),
                        hintText: 'Buscar recursos...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ..._categories.map(
                        (c) => ChoiceChip(
                          label: Text(c['label']),
                          selected: _categoryFilter == c['key'],
                          onSelected: (b) =>
                              setState(() => _categoryFilter = c['key']),
                          backgroundColor: AppColors.background,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _categoryFilter == c['key']
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          showCheckmark: false,
                        ),
                      ),
                      ChoiceChip(
                        avatar: Icon(
                          LucideIcons.star,
                          size: 14,
                          color: _onlyStarred
                              ? AppColors.warning
                              : AppColors.textSecondary,
                        ),
                        label: const Text('Favoritos'),
                        selected: _onlyStarred,
                        onSelected: (b) => setState(() => _onlyStarred = b),
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.warningLight,
                        labelStyle: TextStyle(
                          color: _onlyStarred
                              ? AppColors.warningText
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (ctx, i) {
                final r = filtered[i];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                            ),
                            const Center(
                              child: Icon(
                                LucideIcons.bookOpen,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () => setState(
                                  () => r['starred'] = !r['starred'],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    LucideIcons.star,
                                    size: 18,
                                    color: r['starred']
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              r['author'],
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                r['course'],
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
