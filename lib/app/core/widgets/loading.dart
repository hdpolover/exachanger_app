import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '/app/core/values/app_colors.dart';
import '/app/core/values/app_values.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),

        // Centered loading animation
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppValues.padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppValues.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie animation
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    frameRate: FrameRate.max,
                    errorBuilder: (context, error, stackTrace) {
                      return const SpinKitDoubleBounce(
                        color: AppColors.colorPrimary,
                        size: 80,
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppValues.smallMargin),

                // Loading text
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: AppColors.textColorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
