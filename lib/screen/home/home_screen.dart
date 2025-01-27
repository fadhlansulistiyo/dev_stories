import 'package:dev_stories/provider/stories_provider.dart';
import 'package:dev_stories/screen/home/stories_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../router/page_manager.dart';
import '../../static/result_state.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  final Function(String) onDetail;
  final Function() toAddStoryScreen;

  const HomeScreen(
      {super.key,
      required this.onLogout,
      required this.onDetail,
      required this.toAddStoryScreen});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storiesProvider = context.read<StoriesProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storiesProvider.pageItems != null) {
          storiesProvider.getAllStories();
        }
      }
    });

    Future.microtask(() async => storiesProvider.getAllStories());
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final authRead = context.read<AuthProvider>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Dev Stories'),
          actions: [
            IconButton(
              icon: authWatch.isLoadingLogout
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.logout),
              onPressed: () async {
                final success = await authRead.logout();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authRead.message ??
                        (success ? 'Logout successful.' : 'Logout failed.')),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );

                if (success) {
                  widget.onLogout();
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToUploadPage(context),
          child: const Icon(Icons.add_photo_alternate_outlined),
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
          LoadedState(data: var _) => ListView.builder(
              controller: scrollController,
              itemCount: value.loadedStories.length +
                  (value.pageItems != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == value.loadedStories.length &&
                    value.pageItems != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final stories = value.loadedStories[index];
                return StoriesItem(
                  name: stories.name,
                  description: stories.description,
                  photoUrl: stories.photoUrl,
                  createdAt: stories.createdAt,
                  onTapped: () => widget.onDetail(stories.id),
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

  void _navigateToUploadPage(BuildContext context) async {
    final pageManager = context.read<PageManager>();
    final storiesProvider = context.read<StoriesProvider>();

    widget.toAddStoryScreen();

    final result = await pageManager.waitForResult();

    if (result == "success") {
      await storiesProvider.getAllStories(reset: true);
    }
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
