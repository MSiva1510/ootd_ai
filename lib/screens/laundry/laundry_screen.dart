import 'package:flutter/material.dart';
import 'package:ootd_ai/services/laundry_service.dart';
import 'package:ootd_ai/models/laundry_item.dart';
import 'package:ootd_ai/widgets/empty_state.dart';

class LaundryScreen extends StatefulWidget {
  const LaundryScreen({super.key});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  final LaundryService _laundryService = LaundryService();
  String _selectedTab = 'pending';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final stats = _laundryService.getStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Tracker'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add to laundry feature coming soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Pending',
                      stats['pending'].toString(),
                      Icons.hourglass_empty,
                      Colors.orange,
                      () => setState(() => _selectedTab = 'pending'),
                      _selectedTab == 'pending',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'In Progress',
                      stats['inProgress'].toString(),
                      Icons.local_laundry_service,
                      Colors.blue,
                      () => setState(() => _selectedTab = 'inProgress'),
                      _selectedTab == 'inProgress',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Done',
                      stats['completed'].toString(),
                      Icons.check_circle,
                      Colors.green,
                      () => setState(() => _selectedTab = 'completed'),
                      _selectedTab == 'completed',
                    ),
                  ),
                ],
              ),
            ),

            // Laundry items list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildLaundryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaundryList() {
    late final List<LaundryItem> items;

    if (_selectedTab == 'pending') {
      items = _laundryService.getPendingItems();
    } else if (_selectedTab == 'inProgress') {
      items = _laundryService.getInProgressItems();
    } else {
      items = _laundryService.getCompletedItems();
    }

    if (items.isEmpty) {
      return EmptyState(
        title: 'No items in this category',
        description: 'Add items to track their laundry status',
        icon: Icons.local_laundry_service_outlined,
        actionLabel: 'Add Item',
        onActionPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add to laundry feature coming soon'),
            ),
          );
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildLaundryItemCard(context, item);
      },
    );
  }

  Widget _buildLaundryItemCard(BuildContext context, LaundryItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(item.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.clothingItemName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.washType ?? 'Normal wash',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    item.status.toString().split('.').last,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (item.status != LaundryStatus.completed)
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    if (item.status == LaundryStatus.pending)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _laundryService.updateStatus(
                              item.id,
                              LaundryStatus.inProgress,
                            );
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Status updated'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Start'),
                        ),
                      ),
                    if (item.status == LaundryStatus.inProgress) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _laundryService.updateStatus(
                              item.id,
                              LaundryStatus.completed,
                            );
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Marked as complete'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.done_all),
                          label: const Text('Complete'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(LaundryStatus status) {
    switch (status) {
      case LaundryStatus.pending:
        return Colors.orange;
      case LaundryStatus.inProgress:
        return Colors.blue;
      case LaundryStatus.completed:
        return Colors.green;
    }
  }
}
