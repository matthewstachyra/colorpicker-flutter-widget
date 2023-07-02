import 'package:flutter/material.dart';

class GradientColorPicker extends StatefulWidget {
  @override
  _GradientColorPickerState createState() => _GradientColorPickerState();
}

class _GradientColorPickerState extends State<GradientColorPicker> {
  Color _selectedColor = Colors.transparent;

  void _updateSelectedColor(TapUpDetails details, BoxConstraints constraints) {
    final position = details.localPosition;
    final gradientWidth = constraints.maxWidth;
    final colorPosition = position.dx / gradientWidth;
    setState(() {
      _selectedColor = _getGradientColor(colorPosition);
    });
  }

  Color _getGradientColor(double position) {
    final gradientColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    final startColor = gradientColors[0];
    final endColor = gradientColors[gradientColors.length - 1];
    final selectedColor = Color.lerp(startColor, endColor, position);
    return selectedColor!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (details) => _updateSelectedColor(details, constraints),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gradient Color Picker'),
        ),
        body: Center(
          child: GradientColorPicker(),
        ),
      ),
    ),
  );
}