import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/page_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _searchQuery = '';
  String _categoryFilter = 'all';
  final Map<int, bool> _starred = {};

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
          'Libro de texto fundamental para el curso de Cálculo III. Incluye ejercicios resueltos y problemas aplicados.',
      'starred': true,
      'size': '45 MB',
      'format': 'PDF',
      'cover':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=300&fit=crop',
    },
    {
      'id': 2,
      'type': 'video',
      'title': 'Integrales Dobles - Serie Completa',
      'author': 'Prof. Khan Academy',
      'course': 'Cálculo III',
      'description':
          'Serie de 12 videos explicando integrales dobles desde los conceptos básicos hasta aplicaciones avanzadas.',
      'starred': false,
      'duration': '3h 24min',
      'cover':
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop',
    },
    {
      'id': 3,
      'type': 'article',
      'title': 'Normalización en Base de Datos Relacionales',
      'author': 'Dr. García López',
      'course': 'Base de Datos II',
      'description':
          'Artículo académico sobre las formas normales (1FN hasta BCNF) con ejemplos prácticos y casos de uso empresarial.',
      'starred': true,
      'readTime': '15 min',
      'cover':
          'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=300&fit=crop',
    },
    {
      'id': 4,
      'type': 'tool',
      'title': 'draw.io - Diagramas UML',
      'author': 'Diagrams.net',
      'course': 'Ingeniería de Software',
      'description':
          'Herramienta gratuita online para crear diagramas UML, flujos de procesos, arquitecturas de sistemas y más.',
      'starred': false,
      'free': true,
      'cover':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop',
    },
    {
      'id': 5,
      'type': 'book',
      'title': 'Redes de Computadoras',
      'author': 'Tanenbaum & Wetherall',
      'course': 'Redes de Computadoras',
      'description':
          'La referencia definitiva para redes de computadoras. Cubre desde física de redes hasta protocolos de aplicación.',
      'starred': false,
      'size': '62 MB',
      'cover':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
    },
    {
      'id': 6,
      'type': 'video',
      'title': 'Ética en la Ingeniería de Software',
      'author': 'IEEE Computer Society',
      'course': 'Ética Profesional',
      'description':
          'Conferencia sobre dilemas éticos en el desarrollo de software, responsabilidad profesional y buenas prácticas.',
      'starred': false,
      'duration': '48 min',
      'cover':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
    },
    {
      'id': 7,
      'type': 'tool',
      'title': 'MySQL Workbench',
      'author': 'Oracle',
      'course': 'Base de Datos II',
      'description':
          'IDE visual para diseño, administración y consulta de bases de datos MySQL. Incluye modelado ER y export/import.',
      'starred': true,
      'free': true,
      'cover':
          'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400&h=300&fit=crop',
    },
    {
      'id': 8,
      'type': 'article',
      'title': 'Principios SOLID en Programación',
      'author': 'Robert C. Martin',
      'course': 'Ingeniería de Software',
      'description':
          'Los cinco principios fundamentales del diseño de software orientado a objetos explicados con ejemplos en Java.',
      'starred': false,
      'readTime': '22 min',
      'cover':
          'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=400&h=300&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var r in _resources) {
      _starred[r['id']] = r['starred'] ?? false;
    }
  }

  Future<void> _handleAction(Map<String, dynamic> r) async {
    final isViewer = r['type'] == 'video' || r['type'] == 'tool';

    if (isViewer) {
      final url = Uri.parse('https://www.unad.edu.do/');
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isViewer ? LucideIcons.externalLink : LucideIcons.download,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isViewer
                    ? 'Abriendo recurso...'
                    : 'Descargando ${r['title']}...',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _resources.where((r) {
      final matchSearch =
          r['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          r['author'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          r['course'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchCat = _categoryFilter == 'all' || r['type'] == _categoryFilter;
      return matchSearch && matchCat;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Recursos Educativos',
              subtitle: 'Biblioteca digital con libros, videos y herramientas',
            ),

            // Search & Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
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
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          LucideIcons.search,
                          size: 18,
                          color: AppColors.textTertiary,
                        ),
                        hintText: 'Buscar por título, autor o curso...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final cat = _categories[i];
                        final isSelected = _categoryFilter == cat['key'];
                        return InkWell(
                          onTap: () =>
                              setState(() => _categoryFilter = cat['key']),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat['label'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results summary
            Text(
              '${filtered.length} recursos encontrados',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Resource Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (ctx, i) {
                final r = filtered[i];
                return _ResourceCard(
                  resource: r,
                  isStarred: _starred[r['id']] ?? false,
                  onStarToggle: () => setState(
                    () => _starred[r['id']] = !(_starred[r['id']] ?? false),
                  ),
                  onAction: () => _handleAction(r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final Map<String, dynamic> resource;
  final bool isStarred;
  final VoidCallback onStarToggle;
  final VoidCallback onAction;

  const _ResourceCard({
    required this.resource,
    required this.isStarred,
    required this.onStarToggle,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final type = resource['type'];
    final label = _getTypeLabel(type);
    final typeColor = _getTypeColor(type);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover & Badges
          Stack(
            children: [
              Image.network(
                resource['cover'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 150,
                  color: AppColors.background,
                  child: Center(
                    child: Icon(
                      LucideIcons.image,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: onStarToggle,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isStarred ? LucideIcons.star : LucideIcons.star,
                      size: 16,
                      color: isStarred ? AppColors.warning : Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resource['author'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  resource['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Metadata Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        resource['course'],
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (resource['duration'] != null ||
                        resource['readTime'] != null)
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            resource['duration'] ?? resource['readTime'],
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    if (resource['size'] != null)
                      Text(
                        resource['size'],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    if (resource['free'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GRATIS',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Primary Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type == 'video' || type == 'tool'
                              ? LucideIcons.externalLink
                              : LucideIcons.download,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type == 'video' || type == 'tool'
                              ? 'Abrir Recurso'
                              : 'Descargar Material',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'book':
        return 'Libro';
      case 'video':
        return 'Video';
      case 'article':
        return 'Artículo';
      case 'tool':
        return 'Herramienta';
      default:
        return 'Recurso';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'book':
        return const Color(0xFF2563EB); // Blue
      case 'video':
        return const Color(0xFFDC2626); // Red
      case 'article':
        return const Color(0xFF9333EA); // Purple
      case 'tool':
        return const Color(0xFFD97706); // Amber
      default:
        return AppColors.primary;
    }
  }
}
