import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/features/deep_linking/deep_linking.dart';

/// A page displaying details based on a passed ID.
class DetailsPage extends StatelessWidget {
  /// The ID of the item to display details for.\n
  final String? detailId;

  /// Constructs a [DetailsPage].\n
  const DetailsPage({required this.detailId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareDetailsPage(context),
            tooltip: 'Share this page',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Detail ID: ${detailId ?? "N/A"}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: AppConstants.defaultPadding),

            // Sample detail content
            Card(
              margin: EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    Text(
                      'Sample Details for Item ${detailId ?? "Unknown"}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppConstants.smallPadding),
                    const Text(
                      'This is a sample detail page that can be shared via Firebase Dynamic Links.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppConstants.largePadding),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _shareDetailsPage(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generate and share dynamic link for this details page
  Future<void> _shareDetailsPage(BuildContext context) async {
    if (detailId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot share: No detail ID available')),
      );
      return;
    }

    try {
      // Generate dynamic link using the helper
      final dynamicLink = DynamicLinkGenerator.generateDetailsLink(
        detailId: detailId!,
        queryParams: {
          'shared_at': DateTime.now().millisecondsSinceEpoch.toString(),
          'platform': 'android',
        },
        analytics: CampaignPresets.socialShare,
      );

      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: dynamicLink));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dynamic link copied to clipboard!\n${dynamicLink.substring(0, 50)}...',
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View Full',
              onPressed: () => _showFullLink(context, dynamicLink),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating link: $e')));
      }
    }
  }

  /// Show full dynamic link in a dialog
  void _showFullLink(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Dynamic Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This link will open the app if installed, or redirect to the web version:',
            ),
            SizedBox(height: AppConstants.smallPadding),
            Container(
              padding: EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(link, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
