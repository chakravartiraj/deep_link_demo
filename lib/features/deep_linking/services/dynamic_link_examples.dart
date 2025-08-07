import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dynamic_link_generator.dart';
import 'deep_links_helper.dart';

/// Example usage of DynamicLinkGenerator in your Flutter pages
/// This demonstrates how to integrate dynamic link generation with your existing pages

class DynamicLinkExamples {
  /// Example: Generate and share a Details page link
  static Future<void> shareDetailsPage(
    BuildContext context,
    String detailId,
  ) async {
    // Generate dynamic link for details page
    final dynamicLink = DynamicLinkGenerator.generateDetailsLink(
      detailId: detailId,
      queryParams: {'utm_source': 'app_share', 'ref': 'details_share_button'},
      analytics: CampaignPresets.socialShare,
    );

    // Copy to clipboard or share
    await Clipboard.setData(ClipboardData(text: dynamicLink));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dynamic link copied: ${dynamicLink.substring(0, 50)}...',
          ),
          action: SnackBarAction(
            label: 'View Full',
            onPressed: () => _showFullLink(context, dynamicLink),
          ),
        ),
      );
    }
  }

  /// Example: Generate Profile share link
  static String generateProfileShareLink() {
    return DynamicLinkGenerator.generateProfileLink(
      analytics: CampaignPresets.socialShare,
    );
  }

  /// Example: Generate Report link with query parameters
  static String generateReportLink(
    String reportId, {
    String? status,
    String? filter,
  }) {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (filter != null) queryParams['filter'] = filter;

    return DynamicLinkGenerator.generateReportLink(
      reportId: reportId,
      queryParams: queryParams,
      analytics: const UtmCampaign(
        source: 'app',
        medium: 'report_share',
        campaign: 'report_collaboration',
      ),
    );
  }

  /// Example: Generate links for QR codes
  static String generateQrCodeLink(String path) {
    return DynamicLinkGenerator.generateCustomLink(
      path: path,
      analytics: CampaignPresets.qrCode,
    );
  }

  /// Example: Generate notification deep link
  static String generateNotificationLink(String notificationId, String action) {
    return DynamicLinkGenerator.generateCustomLink(
      path: '/deeplink',
      queryParams: {
        'notification_id': notificationId,
        'action': action,
        'source': 'push_notification',
      },
      analytics: CampaignPresets.notification,
    );
  }

  /// Example: Batch generate links for multiple items
  static List<String> generateBatchLinks(List<String> detailIds) {
    return detailIds
        .map((id) => DynamicLinkGenerator.generateDetailsLink(detailId: id))
        .toList();
  }

  /// Example: Generate link with custom analytics
  static String generateCustomAnalyticsLink(String path) {
    return DynamicLinkGenerator.generateCustomLink(
      path: path,
      analytics: const UtmCampaign(
        source: 'custom_source',
        medium: 'custom_medium',
        campaign: 'custom_campaign',
        term: 'custom_term',
        content: 'custom_content',
      ),
    );
  }

  /// Helper method to show full link in dialog
  static void _showFullLink(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Dynamic Link'),
        content: SelectableText(link),
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

/// Widget to demonstrate dynamic link generation
class DynamicLinkDemo extends StatelessWidget {
  const DynamicLinkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Link Generator Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dynamic Link Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Details page link
            ElevatedButton(
              onPressed: () =>
                  DynamicLinkExamples.shareDetailsPage(context, '123'),
              child: const Text('Share Details Page (ID: 123)'),
            ),

            // Profile link
            ElevatedButton(
              onPressed: () {
                final link = DynamicLinkExamples.generateProfileShareLink();
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile link copied')),
                );
              },
              child: const Text('Generate Profile Link'),
            ),

            // Report link
            ElevatedButton(
              onPressed: () {
                final link = DynamicLinkExamples.generateReportLink(
                  'report_456',
                  status: 'active',
                  filter: 'recent',
                );
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Report link copied: ${link.substring(0, 50)}...',
                    ),
                  ),
                );
              },
              child: const Text('Generate Report Link'),
            ),

            // QR Code link
            ElevatedButton(
              onPressed: () {
                final link = DynamicLinkExamples.generateQrCodeLink(
                  '/deeplink',
                );
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code link copied')),
                );
              },
              child: const Text('Generate QR Code Link'),
            ),

            // Custom link using extension
            ElevatedButton(
              onPressed: () {
                final link = '/profile'.toDynamicLink(
                  analytics: CampaignPresets.emailShare,
                );
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custom link (extension) copied'),
                  ),
                );
              },
              child: const Text('Generate Link with Extension'),
            ),

            const SizedBox(height: 20),
            const Text(
              'Configuration Notes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '• Update dynamicLinkDomain in DynamicLinkGenerator\n'
              '• Replace androidPackage with your actual package name\n'
              '• Update webBaseUrl to your GitHub Pages URL\n'
              '• Configure Firebase Dynamic Links in your project',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
