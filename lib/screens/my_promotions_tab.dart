import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:promorey/providers/auth_provider.dart';
import 'package:promorey/providers/promotion_provider.dart';
import 'package:promorey/widgets/promotion_card.dart';

class MyPromotionsTab extends StatefulWidget {
  const MyPromotionsTab({super.key});

  @override
  State<MyPromotionsTab> createState() => _MyPromotionsTabState();
}

class _MyPromotionsTabState extends State<MyPromotionsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId != null) {
        context.read<PromotionProvider>().loadMyPromotions(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Promociones')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                final uid = context.read<AuthProvider>().user?.uid;
                if (uid != null) await provider.loadMyPromotions(uid);
              },
              child: provider.myPromotions.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aún no has creado ninguna promoción',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.myPromotions.length,
                      itemBuilder: (_, i) {
                        final promotion = provider.myPromotions[i];
                        return PromotionCard(
                          promotion: promotion,
                          onTap: () => context.push('/detail/${promotion.id}'),
                          onEdit: () => context.push('/edit/${promotion.id}'),
                          onDelete: () => _confirmDelete(promotion.id),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // imageUrl removed — Firebase Storage requires paid plan
  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar promoción'),
        content: const Text('¿Estás seguro de eliminar esta promoción?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<PromotionProvider>().deletePromotion(id);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
