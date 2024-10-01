import 'package:flutter/material.dart';

import 'dynamic_widget_builder.dart';

class DynamicSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Map<String, dynamic> onChangedAction;
  final ActionHandler actionHandler;

  DynamicSlider({
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    required this.onChangedAction,
    required this.actionHandler,
  });

  @override
  _DynamicSliderState createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: _sliderValue,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: widget.label ?? _sliderValue.toString(),
          onChanged: (newValue) {
            setState(() {
              _sliderValue = newValue;
            });
            // Call the action handler when the slider value changes
            widget.actionHandler({
              'action': 'sliderChanged',
              'value': newValue,
              ...widget.onChangedAction,
            });
          },
        ),
        Text('Value: ${_sliderValue.toStringAsFixed(2)}'),  // Display the current slider value
      ],
    );
  }
}
