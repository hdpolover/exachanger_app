// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
// import shimmer package
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final double padding;

  const ShimmerWidget({
    super.key,
    this.height = 100,
    this.width = double.infinity,
    this.radius = 6,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(radius),
        ),
        margin: EdgeInsets.all(padding),
      ),
    );
  }
}
