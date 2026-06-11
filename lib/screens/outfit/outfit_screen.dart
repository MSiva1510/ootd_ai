import 'package:flutter/material.dart';
import 'package:ootd_ai/services/outfit_service.dart';
import 'package:ootd_ai/widgets/empty_state.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  final OutfitService _outfitService = OutfitService();
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Favorites',
    'Casual',
    'Formal',
    'Work',
    'Athletic',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final outfits = _outfitService.getAllOutfits();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Outfits'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search feature coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create outfit feature coming soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final option = _filterOptions[index];
                    final isSelected = _selectedFilter == option;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = option;
                          });
                        },
                        label: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Outfits list or empty state
            if (outfits.isEmpty)
              EmptyState(
                title: 'No outfits created yet',
                description: 'Start creating your signature looks',
                icon: Icons.style_outlined,
                actionLabel: 'Create Outfit',
                onActionPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create outfit feature coming soon'),
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = outfits[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${outfit.title} outfit details'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Outfit header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          outfit.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (outfit.occasion != null)
                                          Text(
                                            outfit.occasion!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: colorScheme.outline,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      outfit.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: outfit.isFavorite
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () {
                                      _outfitService
                                          .toggleFavorite(outfit.id);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(outfit.isFavorite
                                              ? 'Removed from favorites'
                                              : 'Added to favorites'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Items count
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      '${outfit.itemIds.length} items',
                                    ),
                                    avatar: const Icon(Icons.checkroom),
                                  ),
                                  const SizedBox(width: 8),
                                  if (outfit.weatherSuitable != null)
                                    Chip(
                                      label: Text(outfit.weatherSuitable!),
                                      avatar: const Icon(Icons.cloud),
                                    ),
                                ],
                              ),

                              if (outfit.ratings > 0) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    ...List.generate(
                                      outfit.ratings,
                                      (index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                    ...List.generate(
                                      5 - outfit.ratings,
                                      (index) => const Icon(
                                        Icons.star_border,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${outfit.ratings}/5',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
