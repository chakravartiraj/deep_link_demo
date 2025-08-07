import 'package:flutter/material.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/deep_linking/services/deep_links_helper.dart';
import 'package:myapp/features/deep_linking/services/dynamic_link_generator.dart';

/// A page displaying report details, often reached via a deep link with
/// both path and query parameters.
class ReportPage extends StatelessWidget {
  /// The ID of the report.
  final String? reportId;

  /// The query parameters associated with the report.
  final Map<String, String> queryParams;

  /// Constructs a [ReportPage].
  const ReportPage({
    required this.reportId,
    required this.queryParams,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(context),
            tooltip: 'Share report',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Report header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.assignment, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Report Details',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'ID: ${reportId ?? "N/A"}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppConstants.defaultPadding),

              // Query parameters section
              if (queryParams.isNotEmpty) ...[
                Text(
                  'Query Parameters:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: AppConstants.smallPadding),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: queryParams.entries.map<Widget>((
                        MapEntry<String, String> entry,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(flex: 3, child: Text(entry.value)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ] else ...[
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No query parameters found.'),
                  ),
                ),
              ],

              SizedBox(height: AppConstants.largePadding),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Return to Home'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _shareReport(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Report'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generate and share dynamic link for this report
  Future<void> _shareReport(BuildContext context) async {
    if (reportId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot share: No report ID available')),
      );
      return;
    }

    try {
      // Include all existing query parameters plus sharing metadata
      final shareQueryParams = Map<String, String>.from(queryParams);
      shareQueryParams.addAll({
        'shared_at': DateTime.now().millisecondsSinceEpoch.toString(),
        'shared_from': 'report_page',
      });

      final dynamicLink = DynamicLinkGenerator.generateReportLink(
        reportId: reportId!,
        queryParams: shareQueryParams,
        analytics: const UtmCampaign(
          source: 'app',
          medium: 'report_share',
          campaign: 'report_collaboration',
          content: 'report_share_button',
        ),
      );

      await Clipboard.setData(ClipboardData(text: dynamicLink));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Report link copied!\n${dynamicLink.substring(0, 50)}...',
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View Full',
              onPressed: () => _showReportLinkDialog(context, dynamicLink),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report link: $e')),
        );
      }
    }
  }

  /// Show the generated report link in a dialog
  void _showReportLinkDialog(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Link - ${reportId ?? "Unknown"}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share this link to let others view this report with all parameters:',
            ),
            SizedBox(height: AppConstants.smallPadding),
            Container(
              padding: EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                link,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            if (queryParams.isNotEmpty) ...[
              SizedBox(height: AppConstants.smallPadding),
              const Text(
                'This link preserves all query parameters for seamless sharing.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
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
                const SnackBar(content: Text('Report link copied!')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
