// lib/providers/content_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content.dart';
import '../services/api_service.dart';
import 'api_service_provider.dart';

// Define a StateNotifierProvider for ContentNotifier
final contentNotifierProvider = StateNotifierProvider<ContentNotifier, AsyncValue<List<Content>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ContentNotifier(apiService);
}, dependencies: [apiServiceProvider]); // Add the dependency on apiServiceProvider

class ContentNotifier extends StateNotifier<AsyncValue<List<Content>>> {
  final ApiService apiService;

  ContentNotifier(this.apiService) : super(const AsyncValue.loading()) {
    fetchContents();
  }

  Future<void> fetchContents() async {
    try {
      final response = await apiService.get('/api/content');
      final contents = (response as List).map((json) => Content.fromJson(json)).toList();
      state = AsyncValue.data(contents);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
