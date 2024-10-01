import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class UsersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch user data using Riverpod's userNotifierProvider
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: userState.when(
        // Show a loading spinner while the data is being fetched
        loading: () => Center(child: CircularProgressIndicator()),

        // Display an error message if there was an error fetching the data
        error: (error, stackTrace) => Center(child: Text('Error: $error')),

        // If data is fetched successfully, display the list of users
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text('No Users Available'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final User user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.id.toString()),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
