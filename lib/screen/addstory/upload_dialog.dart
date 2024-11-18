import 'package:dev_stories/provider/add_story_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const UploadDialog({
    super.key,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isUploading = context.watch<AddStoryProvider>().isUploading;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            isUploading ? Icons.upload_rounded : Icons.check_circle,
            color: isUploading ? Colors.blue : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            isUploading ? 'Uploading...' : 'Upload Completed',
            style: TextStyle(
              color: isUploading ? Colors.blue : Colors.green,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUploading
                ? 'Your story is being uploaded. Please wait...'
                : 'Your story has been successfully uploaded!',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        if (!isUploading)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onComplete();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
