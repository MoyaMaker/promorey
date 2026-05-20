import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:promorey/providers/promotion_provider.dart';
import 'package:promorey/widgets/promotion_card.dart';

class PromotionsTab extends StatefulWidget {
  const PromotionsTab({super.key});

  @override
  State<PromotionsTab> createState() => _PromotionsTabState();
}

class _PromotionsTabState extends State<PromotionsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromotionProvider>().loadActivePromotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Promociones')),
      body: RefreshIndicator(
        onRefresh: () => provider.loadActivePromotions(),
        child: provider.isLoading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : provider.activePromotions.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_offer_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                              const SizedBox(height: 16),
                              Text('Aún no hay promociones', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.activePromotions.length,
                    itemBuilder: (_, i) => PromotionCard(
                      promotion: provider.activePromotions[i],
                      onTap: () => context.push('/detail/${provider.activePromotions[i].id}'),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
