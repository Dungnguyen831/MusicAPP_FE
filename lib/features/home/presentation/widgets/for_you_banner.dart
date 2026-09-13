import 'package:flutter/material.dart';
import 'package:project_test/core/theme/stitch_colors.dart';
import 'package:project_test/core/widgets/liquid_glass_card.dart';

class ForYouBanner extends StatelessWidget {
  const ForYouBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'For you',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StitchColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              addRepaintBoundaries: true,
              addAutomaticKeepAlives: false,
              itemCount: 3, // Mock data, replace with actual data
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: LiquidGlassCard(
                    borderRadius: 24.0,
                    blur: 14.0,
                    backgroundColor: StitchColors.darkSurface.withValues(alpha: 0.4),
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            StitchColors.primary.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                        image: DecorationImage(
                          image: const ResizeImage(
                            NetworkImage('https://picsum.photos/400/200'),
                            width: 800,
                            height: 400,
                          ),
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                          onError: (_, _) {},
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Feel the Beat',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: StitchColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Explore trending tracks and hidden gems curated just for you.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: StitchColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement start listening functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: StitchColors.primary.withValues(alpha: 0.2),
                                foregroundColor: StitchColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(color: StitchColors.borderLight, width: 1.2),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: Text(
                                'Start Listening',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: StitchColors.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
