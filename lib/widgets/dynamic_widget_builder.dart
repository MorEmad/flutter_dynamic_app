import 'package:flutter/material.dart';


import 'DynamicSlider.dart';
import 'ImageCarouselWithDots.dart';

typedef ActionHandler = void Function(Map<String, dynamic> action);

Widget buildDynamicWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  switch (json['type']) {
    case 'Column':
      return buildColumnWidget(json, actionHandler);
    case 'Row':
      return buildRowWidget(json, actionHandler);
    case 'Text':
      return buildTextWidget(json);
    case 'Image':
      return buildImageWidget(json);
    case 'Button':
      return buildButtonWidget(json, actionHandler);
    case 'Container':
      return buildContainerWidget(json, actionHandler);
    case 'Slider':
      return _buildSliderWidget(json, actionHandler); // Use the existing slider function
    case 'ImageCarousel':
      return _buildImageCarouselWidget(json); // Use the existing image carousel function
    case 'Switch':
      return buildSwitchWidget(json, actionHandler);
    case 'SizedBox':
      return buildSizedBoxWidget(json);
    case 'Stack':
      return buildStackWidget(json, actionHandler);
    case 'Center': // Add support for Center
      return buildCenterWidget(json, actionHandler);
    case 'ListView':
      return buildListViewWidget(json, actionHandler);
    default:
      return const SizedBox.shrink();
  }
}

Widget buildListViewWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  final Axis scrollDirection = json['scrollDirection'] == 'horizontal'
      ? Axis.horizontal
      : Axis.vertical;

  return SizedBox(
    height: json['height'] != null ? (json['height'] as num).toDouble() : 200,
    child: ListView(
      scrollDirection: scrollDirection,
      children: (json['children'] as List)
          .map((child) => buildDynamicWidget(child, actionHandler))
          .toList(),
    ),
  );
}
Widget buildColumnWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return Column(
    crossAxisAlignment: _parseCrossAxisAlignment(json['crossAxisAlignment']),
    mainAxisAlignment: _parseMainAxisAlignment(json['mainAxisAlignment']),
    children: (json['children'] as List)
        .map((child) => buildDynamicWidget(child, actionHandler))
        .toList(),
  );
}

Widget buildRowWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return Row(
    crossAxisAlignment: _parseCrossAxisAlignment(json['crossAxisAlignment']),
    mainAxisAlignment: _parseMainAxisAlignment(json['mainAxisAlignment']),
    children: (json['children'] as List)
        .map((child) => buildDynamicWidget(child, actionHandler))
        .toList(),
  );
}

Widget buildCenterWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return Center(
    child: json['child'] != null ? buildDynamicWidget(json['child'], actionHandler) : null,
  );
}
Widget buildTextWidget(Map<String, dynamic> json) {
  return Text(
    json['data'],
    style: TextStyle(
      fontSize: (json['style']['fontSize'] as num?)?.toDouble() ?? 14,
      fontWeight: _parseFontWeight(json['style']['fontWeight']),
      color: _parseColor(json['style']['color']),
    ),
  );
}

Widget buildImageWidget(Map<String, dynamic> json) {
  return Image.network(
    json['url'],
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    fit: _parseBoxFit(json['fit']),
  );
}

Widget buildButtonWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return ElevatedButton(
    onPressed: () {
      actionHandler(json['action']);
    },
    child: Text(json['text']),
  );
}

Widget buildContainerWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return Container(
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    color: _parseColor(json['color']),
    padding: _parseEdgeInsets(json['padding']),
    margin: _parseEdgeInsets(json['margin']),
    child: json['child'] != null ? buildDynamicWidget(json['child'], actionHandler) : null,
  );
}

Widget buildSliderWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return DynamicSlider(
    value: (json['value'] as num?)?.toDouble() ?? 0.0,
    min: (json['min'] as num?)?.toDouble() ?? 0.0,
    max: (json['max'] as num?)?.toDouble() ?? 100.0,
    divisions: (json['divisions'] as num?)?.toInt(),
    label: json['label'],
    onChangedAction: json['onChanged'],
    actionHandler: actionHandler,
  );
}

Widget buildImageCarouselWidget(Map<String, dynamic> json) {
  final List<String> images = List<String>.from(json['images']);
  return ImageCarouselWithDots(
    images: images,
    height: (json['height'] as num?)?.toDouble() ?? 200.0,
    autoPlay: json['autoPlay'] ?? true,
    enlargeCenterPage: json['enlargeCenterPage'] ?? true,
    viewportFraction: json['viewportFraction'] ?? 0.8,
  );
}

Widget buildSwitchWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  bool value = json['value'] ?? false;
  return StatefulBuilder(
    builder: (context, setState) {
      return Switch(
        value: value,
        activeColor: _parseColor(json['activeColor']),
        onChanged: (newValue) {
          setState(() {
            value = newValue;
          });
          actionHandler({
            'action': 'toggleSwitch',
            'value': newValue,
          });
        },
      );
    },
  );
}

Widget buildSizedBoxWidget(Map<String, dynamic> json) {
  return SizedBox(
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
  );
}

Widget buildStackWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return Stack(
    children: (json['children'] as List)
        .map((child) => buildDynamicWidget(child, actionHandler))
        .toList(),
  );
}

// Helper functions for parsing JSON properties

FontWeight _parseFontWeight(String? weight) {
  switch (weight) {
    case 'bold':
      return FontWeight.bold;
    case 'normal':
    default:
      return FontWeight.normal;
  }
}

Color _parseColor(String? colorString) {
  if (colorString == null) return Colors.black;
  String hex = colorString.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // Add alpha if not provided
  }
  return Color(int.parse(hex, radix: 16));
}

BoxFit _parseBoxFit(String? fit) {
  switch (fit) {
    case 'cover':
      return BoxFit.cover;
    case 'contain':
      return BoxFit.contain;
    case 'fill':
      return BoxFit.fill;
    default:
      return BoxFit.cover;
  }
}

EdgeInsets _parseEdgeInsets(dynamic json) {
  if (json is num) {
    return EdgeInsets.all(json.toDouble());
  } else if (json is Map<String, dynamic>) {
    return EdgeInsets.only(
      left: (json['left'] as num?)?.toDouble() ?? 0,
      right: (json['right'] as num?)?.toDouble() ?? 0,
      top: (json['top'] as num?)?.toDouble() ?? 0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0,
    );
  }
  return EdgeInsets.zero;
}

// Helper function to parse MainAxisAlignment from JSON
MainAxisAlignment _parseMainAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'center':
      return MainAxisAlignment.center;
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

// Helper function to parse CrossAxisAlignment from JSON
CrossAxisAlignment _parseCrossAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'center':
      return CrossAxisAlignment.center;
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
    default:
      return CrossAxisAlignment.start;
  }
}



// Dynamic widget builder for ImageCarousel with dots
Widget _buildImageCarouselWidget(Map<String, dynamic> json) {
  final List<String> images = List<String>.from(json['images']);
  return ImageCarouselWithDots(
    images: images,
    height: (json['height'] as num?)?.toDouble() ?? 200.0,
    autoPlay: json['autoPlay'] ?? true,
    enlargeCenterPage: json['enlargeCenterPage'] ?? true,
    viewportFraction: json['viewportFraction'] ?? 0.8,
  );
}


// Dynamic widget builder for Slider
Widget _buildSliderWidget(Map<String, dynamic> json, ActionHandler actionHandler) {
  return DynamicSlider(
    value: (json['value'] as num?)?.toDouble() ?? 0.0,
    min: (json['min'] as num?)?.toDouble() ?? 0.0,
    max: (json['max'] as num?)?.toDouble() ?? 100.0,
    divisions: (json['divisions'] as num?)?.toInt(),
    label: json['label'],
    onChangedAction: json['onChanged'],
    actionHandler: actionHandler,
  );
}