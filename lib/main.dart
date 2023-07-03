import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Color Picker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gradient Color Picker'),
        ),
        body: Center(
          child: Container(
            width: 200,
            height: 400,
            child: GradientColorPicker(),
          ),
        ),
      ),
    );
  }
}

class GradientColorPicker extends StatefulWidget {
  @override
  _GradientColorPickerState createState() => _GradientColorPickerState();
}

class _GradientColorPickerState extends State<GradientColorPicker> {
  double _selectedPosition = 0.5;

  Color _getColorFromPosition(double position) {
    final int red = (255 - (255 * position)).round();
    final int blue = (255 * position).round();
    return Color.fromRGBO(red, 0, blue, 1.0);
  }

  void _updateSelectedPosition(Offset position, BoxConstraints constraints) {
    final double newPosition = position.dy / constraints.maxHeight;
    setState(() {
      _selectedPosition = newPosition.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            _updateSelectedPosition(details.localPosition, constraints);
          },
          onTapDown: (TapDownDetails details) {
            _updateSelectedPosition(details.localPosition, constraints);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              painter: _SelectedColorPainter(
                _selectedPosition,
                constraints.maxWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedColorPainter extends CustomPainter {
  final double position;
  final double width;

  _SelectedColorPainter(this.position, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final double barHeight = 10.0;
    final double barExtend = 6.0;

    final double lineHeight = size.height * position;
    final double lineY = lineHeight - barHeight / 2;
    final double lineBottomY = lineY + barHeight;

    final double gradientWidth = size.width;
    final double barWidth = gradientWidth + barExtend * 2;

    final double lineLeftX = -barExtend;
    final double lineRightX = lineLeftX + barWidth;

    final Rect lineRect = Rect.fromLTRB(lineLeftX, lineY, lineRightX, lineBottomY);
    final RRect lineRRect = RRect.fromRectAndRadius(
      lineRect,
      Radius.circular(barHeight / 2),
    );

    final Paint selectedColorPaint = Paint()
      ..color = Colors.grey.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(lineRRect, selectedColorPaint);
  }

  @override
  bool shouldRepaint(_SelectedColorPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.width != width;
  }
}
