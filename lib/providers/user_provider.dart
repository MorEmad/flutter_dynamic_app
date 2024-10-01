// lib/providers/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'api_service_provider.dart';

// Define a StateNotifierProvider for UserNotifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserNotifier(apiService);
}, dependencies: [apiServiceProvider]); // Add the dependency on apiServiceProvider

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final ApiService apiService;

  UserNotifier(this.apiService) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await apiService.get('/api/users');
      final users = (response as List).map((json) => User.fromJson(json)).toList();
      state = AsyncValue.data(users);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
