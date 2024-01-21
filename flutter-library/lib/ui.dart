import 'package:flutter/material.dart';

// Continuous
class UIWidgetSlider extends StatefulWidget {
  const UIWidgetSlider({super.key});

  @override
  State<UIWidgetSlider> createState() => _UIWidgetSliderState();
}

class _UIWidgetSliderState extends State<UIWidgetSlider> {
  double _sliderValue = 20;
  double start = 0.0;
  double end = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('${start.round()}'),
            Expanded(
              child: Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                label: _sliderValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
            ),
            Text(_sliderValue == 0.0 ? '100' : _sliderValue.round().toString()),
          ],
        ),
      ),
    ));
  }
}

// Discrete
class UIWidgetSlider2 extends StatefulWidget {
  const UIWidgetSlider2({super.key});

  @override
  State<UIWidgetSlider2> createState() => _UIWidgetSlider2State();
}

class _UIWidgetSlider2State extends State<UIWidgetSlider2> {
  RangeValues _rangeSliderDiscreteValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: RangeSlider(
        values: _rangeSliderDiscreteValues,
        min: 0,
        max: 100,
        divisions: 5,
        labels: RangeLabels(
          _rangeSliderDiscreteValues.start.round().toString(),
          _rangeSliderDiscreteValues.end.round().toString(),
        ),
        onChanged: (values) {
          setState(() {
            _rangeSliderDiscreteValues = values;
          });
        },
      ),
    ));
  }
}
