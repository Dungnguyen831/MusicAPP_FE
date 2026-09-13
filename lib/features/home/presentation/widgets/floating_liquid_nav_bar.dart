import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart';
import 'package:project_test/core/widgets/liquid_glass_card.dart';

class FloatingLiquidNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const FloatingLiquidNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<FloatingLiquidNavBar> createState() => _FloatingLiquidNavBarState();
}

class _FloatingLiquidNavBarState extends State<FloatingLiquidNavBar> {
  late int _localSelectedIndex;
  double _dragPosition = -1.0; // -1 means no active drag
  double _itemWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _localSelectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant FloatingLiquidNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _localSelectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 36px horizontal padding for the whole bar + 24px margin in home_screen
    // We should better use a fixed width or percentage based on parent constraints.
    // For simplicity, let's assume it takes full width minus horizontal padding in HomeScreen
    final barWidth = MediaQuery.of(context).size.width - 48; // 24 * 2
    _itemWidth = barWidth / 3; 

    return RepaintBoundary(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
          child: GestureDetector(
            onTapUp: _handleTapUp,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: LiquidGlassCard(
              borderRadius: 36.0,
              blur: 16.0,
              backgroundColor: StitchColors.darkSurface.withValues(alpha: 0.45),
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 72,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Moving background circle
                    AnimatedPositioned(
                      duration: _dragPosition == -1.0 
                          ? const Duration(milliseconds: 300) 
                          : Duration.zero,
                      curve: Curves.easeOutCubic,
                      left: _dragPosition == -1.0 
                          ? _localSelectedIndex * _itemWidth 
                          : (_dragPosition - (_itemWidth / 2)).clamp(0.0, barWidth - _itemWidth),
                      width: _itemWidth,
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: StitchColors.primary,
                            borderRadius: BorderRadius.circular(28.0),
                            boxShadow: [
                              BoxShadow(
                                color: StitchColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildNavItem(0, Icons.home_rounded),
                        _buildNavItem(1, Icons.library_music_rounded),
                        _buildNavItem(2, Icons.settings_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapUp(TapUpDetails details) {
    final tapX = details.localPosition.dx;
    final newIndex = (tapX / _itemWidth).floor().clamp(0, 2);
    if (newIndex != _localSelectedIndex) {
      setState(() {
        _localSelectedIndex = newIndex;
        widget.onItemSelected.call(newIndex);
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.localPosition.dx;
      // Real-time tab switching during drag
      final currentIndex = (_dragPosition / _itemWidth).floor().clamp(0, 2);
      if (currentIndex != _localSelectedIndex) {
        _localSelectedIndex = currentIndex;
        widget.onItemSelected.call(currentIndex);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _dragPosition = -1.0; // Return to snap animation
    });
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = index == _localSelectedIndex;
    return Expanded(
      child: Icon(
        icon,
        color: isSelected ? StitchColors.darkBackground : StitchColors.textSecondary,
        size: 28,
      ),
    );
  }
}
