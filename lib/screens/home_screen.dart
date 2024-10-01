// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/dynamic_widget_builder.dart';
import '../providers/content_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the UI schema or dynamic content as needed
    ref.read(contentNotifierProvider.notifier).fetchContents();
  }

  void _handleAction(Map<String, dynamic>? action) {
    if (action == null) return;

    switch (action['type']) {
      case 'navigate':
        final route = action['route'];
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
        break;
    // Handle other action types
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Flutter App'),
      ),
      body: contentState.when(
        data: (contents) {
          // Assuming the first content item defines the UI schema
          if (contents.isNotEmpty) {
            final uiSchema = contents.first.body; // Adjust based on your JSON structure
            if (uiSchema is Map<String, dynamic>) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: buildDynamicWidget(uiSchema, _handleAction),
              );
            } else {
              return Center(child: Text('Invalid UI Schema'));
            }
          } else {
            return Center(child: Text('No Content Available'));
          }
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
