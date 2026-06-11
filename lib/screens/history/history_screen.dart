import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ootd_ai/services/outfit_service.dart';
import 'package:ootd_ai/widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final OutfitService _outfitService = OutfitService();
  String _sortBy = 'recent';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var outfits = _outfitService.getAllOutfits();

    // Sort outfits
    if (_sortBy == 'recent') {
      outfits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'rated') {
      outfits.sort((a, b) => b.ratings.compareTo(a.ratings));
    } else if (_sortBy == 'oldest') {
      outfits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit History'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Most Recent'),
              ),
              const PopupMenuItem(
                value: 'rated',
                child: Text('Highest Rated'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Oldest First'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: outfits.isEmpty
          ? EmptyState(
              title: 'No outfit history',
              description: 'Create your first outfit to start tracking history',
              icon: Icons.history_outlined,
              actionLabel: 'Create Outfit',
              onActionPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create outfit feature coming soon'),
                  ),
                );
              },
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStatsSection(context, colorScheme, outfits),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildHistoryTimeline(context, colorScheme, outfits),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, ColorScheme colorScheme, List<dynamic> outfits) {
    final totalOutfits = outfits.length;
    final favoriteOutfits =
        outfits.where((o) => o.isFavorite).length;
    final averageRating = outfits.isEmpty
    ? 0.0
    : outfits.fold(
        0.0,
        (sum, o) => sum + o.ratings.toDouble(),
      ) /
      totalOutfits;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total Outfits',
                  totalOutfits.toString(),
                  Icons.style,
                ),
                _buildStatItem(
                  context,
                  'Favorites',
                  favoriteOutfits.toString(),
                  Icons.favorite,
                ),
                _buildStatItem(
                  context,
                  'Avg Rating',
                  averageRating.toStringAsFixed(1),
                  Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Widget _buildHistoryTimeline(
      BuildContext context, ColorScheme colorScheme, List<dynamic> outfits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: outfits.length,
          itemBuilder: (context, index) {
            final outfit = outfits[index];
            final isFirst = index == 0;
            final isLast = index == outfits.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dot and line
                Column(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: outfit.isFavorite
                            ? Colors.red
                            : colorScheme.primary,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 120,
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: isFirst ? 0 : 8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    outfit.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                if (outfit.isFavorite)
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              intl.DateFormat('MMM d, y - h:mm a')
                                  .format(outfit.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                  label: Text(
                                      '${outfit.itemIds.length} items'),
                                  avatar: const Icon(Icons.checkroom),
                                  visualDensity: VisualDensity.compact,
                                ),
                                if (outfit.occasion != null)
                                  Chip(
                                    label: Text(outfit.occasion!),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                if (outfit.ratings > 0)
                                  Chip(
                                    label: Text('${outfit.ratings}★'),
                                    visualDensity: VisualDensity.compact,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
