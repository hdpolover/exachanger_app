import 'package:flutter/material.dart';

class CustomCarouselView extends StatelessWidget {
  final List<Widget> children;
  final Function(int) onTap;
  final EdgeInsetsGeometry padding;
  final OutlinedBorder shape;
  final bool itemSnapping;
  final double itemExtent;
  final double spacing;
  const CustomCarouselView({
    Key? key,
    required this.children,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.shape = const RoundedRectangleBorder(),
    this.itemSnapping = true,
    required this.itemExtent,
    this.spacing = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: padding,
      itemCount: children.length,
      itemExtent: itemExtent + spacing, // Add spacing to item extent
      physics: itemSnapping
          ? const PageScrollPhysics()
          : const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: EdgeInsets.only(right: spacing),
            child: Card(
              shape: shape,
              child: children[index],
            ),
          ),
        );
      },
    );
  }
}
