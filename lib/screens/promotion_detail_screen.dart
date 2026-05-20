import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promorey/models/promotion.dart';
import 'package:promorey/services/firestore_service.dart';
import 'package:share_plus/share_plus.dart' show Share;

class PromotionDetailScreen extends StatefulWidget {
  final String promotionId;
  const PromotionDetailScreen({super.key, required this.promotionId});

  @override
  State<PromotionDetailScreen> createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {
  Promotion? _promotion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final firestore = FirestoreService();
    final promotion = await firestore.getPromotionById(widget.promotionId);
    if (mounted) {
      setState(() {
        _promotion = promotion;
        _isLoading = false;
      });
    }
  }

  void _share() {
    if (_promotion == null) return;
    final p = _promotion!;
    final text = '''
${p.title}

${p.description}

Fecha: ${DateFormat.yMMMd().format(p.date)}
''';
    Share.share(text, subject: p.title);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final p = _promotion;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Promoción no encontrada')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image removed — Firebase Storage requires paid plan
            Row(
              children: [
                Expanded(
                  child: Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: p.isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: p.isActive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(p.date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 24),
            Text(p.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _share,
                icon: const Icon(Icons.share),
                label: const Text('Compartir promoción'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
