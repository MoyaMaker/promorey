import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promorey/models/promotion.dart';
import 'package:share_plus/share_plus.dart' show Share;

class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PromotionCard({
    super.key,
    required this.promotion,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  void _share(BuildContext context) {
    final text = '''
${promotion.title}

${promotion.description}

Fecha: ${DateFormat.yMMMd().format(promotion.date)}
''';
    Share.share(text, subject: promotion.title);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image removed — Firebase Storage requires paid plan
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          promotion.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: promotion.isActive ? Colors.lightGreen[500] : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          promotion.isActive ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            fontSize: 12,
                            color: promotion.isActive ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().format(promotion.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promotion.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, size: 20),
                        onPressed: () => _share(context),
                        tooltip: 'Compartir',
                      ),
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: onEdit,
                          tooltip: 'Editar',
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: onDelete,
                          tooltip: 'Eliminar',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
