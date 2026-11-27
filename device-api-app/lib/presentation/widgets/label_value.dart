import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class LabelValueEntry {
  final String label;
  final String value;

  const LabelValueEntry({
    required this.label,
    required this.value,
  });
}

class LabelValueGroup extends StatelessWidget {
  final List<LabelValueEntry> entries;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const LabelValueGroup({
    super.key,
    required this.entries,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectiveLabelStyle =
        labelStyle ?? EgovText.medium.copyWith(color: EgovColor.gray70);
    final labelWidth = _maxLabelWidth(
      context,
      entries.map((entry) => entry.label).toList(),
      effectiveLabelStyle,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          LabelValueRow(
            label: entries[i].label,
            value: entries[i].value,
            labelWidth: labelWidth,
            padding: padding,
            labelStyle: effectiveLabelStyle,
            valueStyle: valueStyle,
          ),
        ],
      ],
    );
  }
}

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final double? labelWidth;
  final EdgeInsetsGeometry padding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double gap;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.labelStyle,
    this.valueStyle,
    this.gap = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle =
        labelStyle ?? EgovText.medium.copyWith(color: EgovColor.gray70);
    final effectiveValueStyle = valueStyle ??
        EgovText.medium.copyWith(
          color: EgovColor.primary50,
          fontWeight: FontWeight.w700,
        );

    final labelWidget = Text(
      label,
      style: effectiveLabelStyle,
    );

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: EgovColor.gray5,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.gray20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelWidth != null)
            SizedBox(width: labelWidth, child: labelWidget)
          else
            labelWidget,
          SizedBox(width: gap),
          Expanded(
            child: Text(
              value,
              style: effectiveValueStyle,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

double _maxLabelWidth(
  BuildContext context,
  List<String> labels,
  TextStyle style,
) {
  var maxWidth = 0.0;

  for (final label in labels) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    if (painter.width > maxWidth) {
      maxWidth = painter.width;
    }
  }

  return maxWidth + 8;
}
