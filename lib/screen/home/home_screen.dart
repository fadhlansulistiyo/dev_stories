import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  final Function() onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Stories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authProvider = context.read<AuthProvider>();
          final success = await authProvider.logout();

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.message ??
                  (success ? 'Logout successful.' : 'Logout failed.')),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );

          if (success) {
            onLogout();
          }
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
