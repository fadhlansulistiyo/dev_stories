import 'package:dev_stories/provider/stories_provider.dart';
import 'package:dev_stories/screen/home/stories_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../static/result_state.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  final Function(String) onDetail;

  const HomeScreen({super.key, required this.onLogout, required this.onDetail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<StoriesProvider>().getAllStories();
      }
    });
  }

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
              widget.onLogout();
            }
          },
          child: const Icon(Icons.logout),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return Consumer<StoriesProvider>(
      builder: (context, value, _) {
        return switch (value.storiesState) {
          LoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
          LoadedState(data: var listStory) => ListView.builder(
              itemCount: listStory.length,
              itemBuilder: (context, index) {
                final stories = listStory[index];
                return StoriesItem(
                  name: stories.name,
                  description: stories.description,
                  photoUrl: stories.photoUrl,
                  createdAt: stories.createdAt,
                  onTapped: () => widget.onDetail(stories.id)
                );
              },
            ),
          ErrorState(error: var message) => Center(
              child: _buildError(message),
            ),
          _ => const SizedBox()
        };
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryFetchingData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _retryFetchingData() {
    final provider = context.read<StoriesProvider>();
    provider.getAllStories();
  }
}
