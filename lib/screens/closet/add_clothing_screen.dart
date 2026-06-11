import 'package:flutter/material.dart';
import 'package:ootd_ai/models/clothing_item.dart';
import 'package:ootd_ai/services/clothing_service.dart';

/// Screen for adding a new clothing item
class AddClothingScreen extends StatefulWidget {
  const AddClothingScreen({Key? key}) : super(key: key);

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  late ClothingService _clothingService;
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  
  // Form state
  String _selectedCategory = 'Shirt';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _clothingService = ClothingService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  /// Validate and save the clothing item
  void _saveClothing() {
    if (_formKey.currentState!.validate()) {
      // Create new clothing item
      final newItem = ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        color: _colorController.text.trim(),
        status: 'Available',
        dateAdded: DateTime.now(),
      );

      // Add to service
      _clothingService.addClothingItem(newItem);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newItem.name} added successfully!'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to closet screen
      Navigator.pop(context, true);
    }
  }

  /// Cancel and go back
  void _cancel() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing Item'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.checkroom,
                      size: 48,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add New Clothing Item',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Clothing Name Field
              Text(
                'Clothing Name *',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Blue Formal Shirt',
                  prefixIcon: const Icon(Icons.checkroom),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter clothing name';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              Text(
                'Category *',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: ClothingItem.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(category),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Color Field
              Text(
                'Color *',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  hintText: 'e.g., Blue, Red, Black',
                  prefixIcon: const Icon(Icons.palette),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter color';
                  }
                  if (value.trim().length < 2) {
                    return 'Please enter a valid color';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Available Colors Reference
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Colors',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Blue',
                        'White',
                        'Black',
                        'Red',
                        'Green',
                        'Yellow',
                        'Grey',
                        'Brown',
                        'Pink',
                        'Orange',
                        'Purple',
                        'Navy',
                      ]
                          .map((color) => Chip(
                                label: Text(color),
                                onDeleted: () {
                                  _colorController.text = color;
                                },
                                deleteIcon: const SizedBox.shrink(),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Save Button
                  Expanded(
                    child: FilledButton(
                      onPressed: _saveClothing,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Info Text
              Center(
                child: Text(
                  'Fields marked with * are required',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}