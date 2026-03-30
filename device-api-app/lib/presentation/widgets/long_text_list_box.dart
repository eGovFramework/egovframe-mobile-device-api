import 'package:flutter/material.dart';

class LongTextListBox extends StatelessWidget {
  final String title;
  final List<String> items;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Color bulletColor;
  final double bulletSize;
  final double itemSpacing;
  final double lineHeight;

  const LongTextListBox({
    super.key,
    required this.title,
    required this.items,
    this.padding,
    this.margin,
    this.decoration,
    this.bulletColor = Colors.blue,
    this.bulletSize = 6.0,
    this.itemSpacing = 12.0,
    this.lineHeight = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin ?? const EdgeInsets.only(bottom: 16.0),
      decoration: decoration ?? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12.0),
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: itemSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: bulletSize,
                  height: bulletSize,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: BoxDecoration(
                    color: bulletColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: lineHeight,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}











