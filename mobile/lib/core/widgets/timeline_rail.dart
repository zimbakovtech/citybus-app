import 'package:flutter/material.dart';

/// Vertical timeline marker: a dot with connector lines above/below, used for
/// ordered stop lists and journey legs so all "sequence" UIs read the same.
class TimelineRail extends StatelessWidget {
  const TimelineRail({
    super.key,
    required this.color,
    this.drawTop = true,
    this.drawBottom = true,
    this.emphasized = false,
    this.width = 40,
  });

  final Color color;
  final bool drawTop;
  final bool drawBottom;

  /// Terminus/boarding points get a filled square dot; intermediate points a
  /// small outlined one.
  final bool emphasized;

  final double width;

  @override
  Widget build(BuildContext context) {
    final dotSize = emphasized ? 14.0 : 10.0;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(width: 2, color: drawTop ? color : null),
            ),
          ),
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: emphasized ? color : Theme.of(context).colorScheme.surface,
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(width: 2, color: drawBottom ? color : null),
            ),
          ),
        ],
      ),
    );
  }
}
