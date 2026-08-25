import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart';
import 'package:project_test/core/widgets/liquid_glass_card.dart';

class CategoryFilterBar extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty && !widget.categories.contains(_selectedCategory)) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isActive = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: isActive
                ? _buildActivePill(category)
                : _buildInactivePill(category),
          );
        },
      ),
    );
  }

  Widget _buildActivePill(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
          widget.onCategorySelected?.call(category);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: StitchColors.primary,
        foregroundColor: StitchColors.darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: StitchColors.darkBackground,
            ),
      ),
    );
  }

  Widget _buildInactivePill(String category) {
    return LiquidGlassCard(
      borderRadius: 20.0,
      blur: 10.0,
      backgroundColor: StitchColors.darkSurface.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
            widget.onCategorySelected?.call(category);
          });
        },
        child: Text(
          category,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: StitchColors.neutral,
              ),
        ),
      ),
    );
  }
}
