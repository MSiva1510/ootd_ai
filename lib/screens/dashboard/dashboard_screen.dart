import 'package:flutter/material.dart';
import 'package:ootd_ai/services/clothing_service.dart';
import 'package:ootd_ai/services/outfit_service.dart';
import 'package:ootd_ai/services/laundry_service.dart';
import 'package:ootd_ai/widgets/stat_card.dart';
// ignore: unused_import
import 'package:ootd_ai/models/clothing_item.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ClothingService _clothingService = ClothingService();
  final OutfitService _outfitService = OutfitService();
  final LaundryService _laundryService = LaundryService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OOTD AI'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s find you the perfect outfit today',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Generate outfit feature coming soon'),
                        ),
                      );
                    },
                    child: const Text('Generate Outfit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick stats
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                StatCard(
                  title: 'Clothing Items',
                  value: _clothingService.getAllClothes().length.toString(),
                  icon: Icons.checkroom,
                ),
                StatCard(
                  title: 'Outfits',
                  value: _outfitService.getAllOutfits().length.toString(),
                  icon: Icons.style,
                ),
                StatCard(
                  title: 'Laundry',
                  value: _laundryService.getPendingItems().length.toString(),
                  icon: Icons.local_laundry_service,
                ),
                StatCard(
                  title: 'Favorites',
                  value:
                      _outfitService.getFavoriteOutfits().length.toString(),
                  icon: Icons.favorite,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent outfits section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Outfits',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('View all outfits in History tab'),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_outfitService.getAllOutfits().isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.style_outlined,
                        size: 48,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No outfits yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    _outfitService.getAllOutfits().length.clamp(0, 3),
                itemBuilder: (context, index) {
                  final outfit = _outfitService.getAllOutfits()[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        Icons.style,
                        color: colorScheme.primary,
                      ),
                      title: Text(outfit.title),
                      subtitle: Text(
                        outfit.occasion ?? 'No occasion',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        outfit.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: outfit.isFavorite ? Colors.red : null,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
