import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatefulWidget {
  final List<PieData> data;
  final double chartRadius;
  final double radialLine;
  final double horizontalLine;
  final double outerMargin;
  final double startDegree;
  final double? space;
  final TextStyle? labelStyle;

  const CustomPieChart({
    super.key,
    required this.data,
    this.chartRadius = 50,
    this.radialLine = 60,
    this.horizontalLine = 50,
    this.outerMargin = 40,
    this.startDegree = -90,
    this.space,
    this.labelStyle
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int? _hoveredIndex;

  double _normalize(double a) {
    final twoPi = 2 * math.pi;
    a = a % twoPi;
    if (a < 0) a += twoPi;
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final canvasSize = widget.chartRadius * 2 + widget.outerMargin * 2;
    final total = widget.data.fold<double>(0, (s, d) => s + d.value);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                MouseRegion(
                  onHover: (event) {
                    final center = Offset(canvasSize / 2, canvasSize / 2);
                    final dx = event.localPosition.dx - center.dx;
                    final dy = event.localPosition.dy - center.dy;
                    final distance = math.sqrt(dx * dx + dy * dy);

                    if (distance > widget.chartRadius + 10) {
                      setState(() => _hoveredIndex = null);
                      return;
                    }

                    double angle = math.atan2(dy, dx);
                    angle = _normalize(angle);

                    double runningAngle = _normalize(
                      widget.startDegree * math.pi / 180,
                    );

                    for (int i = 0; i < widget.data.length; i++) {
                      final sweep =
                          (widget.data[i].value / total) * 2 * math.pi;
                      final end = _normalize(runningAngle + sweep);

                      bool inside;
                      if (runningAngle < end) {
                        inside = angle >= runningAngle && angle < end;
                      } else {
                        inside = angle >= runningAngle || angle < end;
                      }

                      if (inside) {
                        setState(() => _hoveredIndex = i);
                        return;
                      }

                      runningAngle = end;
                    }

                    setState(() => _hoveredIndex = null);
                  },
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: SizedBox(
                    width: canvasSize,
                    height: canvasSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.square(
                          dimension: widget.chartRadius * 2,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: widget.startDegree,
                              centerSpaceRadius: 50,
                              sectionsSpace: widget.space,
                              borderData: FlBorderData(show: false),
                              sections: List.generate(widget.data.length, (
                                index,
                              ) {
                                final d = widget.data[index];
                                final isHovered = index == _hoveredIndex;
                                return PieChartSectionData(
                                  value: d.value,
                                  color: d.color,
                                  radius: isHovered
                                      ? widget.chartRadius + 10
                                      : widget.chartRadius,
                                  showTitle: false,
                                );
                              }),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _LabelLinePainter(
                              data: widget.data,
                              chartRadius: widget.chartRadius,
                              hoveredIndex: _hoveredIndex,
                              hoverExtra: 10,
                              radialLen: widget.radialLine,
                              horizontalLen: widget.horizontalLine,
                              startDegreeDeg: widget.startDegree,
                              labelColor: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: List.generate(widget.data.length, (index) {
                    final d = widget.data[index];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: d.color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          d.name,
                          style: widget.labelStyle ?? TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            // color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PieData {
  final String name;
  final double value;
  final Color color;
  const PieData(this.name, this.value, this.color);
}

class _LabelLinePainter extends CustomPainter {
  final List<PieData> data;
  final double chartRadius;
  final int? hoveredIndex;
  final double hoverExtra;
  final double radialLen;
  final double horizontalLen;
  final double startDegreeDeg;
  final Color labelColor;

  _LabelLinePainter({
    required this.data,
    required this.chartRadius,
    this.hoveredIndex,
    this.hoverExtra = 0,
    required this.radialLen,
    required this.horizontalLen,
    required this.startDegreeDeg,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startAngle = startDegreeDeg * math.pi / 180.0;
    final total = data.fold<double>(0, (s, d) => s + d.value);
    if (total == 0) return;

    double runningAngle = startAngle;

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      if (d.value <= 0) continue;

      final sweep = (d.value / total) * 2 * math.pi;
      final mid = runningAngle + sweep / 2;

      final sliceRadius =
          chartRadius +
          ((hoveredIndex != null && hoveredIndex == i) ? hoverExtra : 0);

      final pEdge = Offset(
        center.dx + math.cos(mid) * sliceRadius,
        center.dy + math.sin(mid) * sliceRadius,
      );

      final pRadial = Offset(
        center.dx + math.cos(mid) * (sliceRadius + radialLen),
        center.dy + math.sin(mid) * (sliceRadius + radialLen),
      );

      final isLeft = mid > math.pi / 2 && mid < 3 * math.pi / 2;
      final pElbowEnd = Offset(
        pRadial.dx + (isLeft ? -horizontalLen : horizontalLen),
        pRadial.dy,
      );

      final paint = Paint()
        ..color = d.color
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke;

      canvas.drawLine(pEdge, pRadial, paint);
      canvas.drawLine(pRadial, pElbowEnd, paint);

      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${d.name}\n",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: labelColor,
              ),
            ),
            TextSpan(
              text: d.value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: d.color,
              ),
            ),
          ],
        ),
        textAlign: isLeft ? TextAlign.right : TextAlign.left,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 100);

      final offset = isLeft
          ? Offset(pElbowEnd.dx - tp.width - 4, pElbowEnd.dy - tp.height / 2)
          : Offset(pElbowEnd.dx + 4, pElbowEnd.dy - tp.height / 2);

      tp.paint(canvas, offset);

      runningAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _LabelLinePainter old) =>
      data != old.data ||
      chartRadius != old.chartRadius ||
      radialLen != old.radialLen ||
      horizontalLen != old.horizontalLen ||
      hoveredIndex != old.hoveredIndex ||
      startDegreeDeg != old.startDegreeDeg;
}
