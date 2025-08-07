import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../dynamic_link_generator.dart';
import '../dynamic_link_examples.dart';

/// The home page of the application.
///
/// This page provides navigation options to other pages, a dialog, and a
/// bottom sheet.
class HomePage extends StatelessWidget {
  /// Constructs a [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareHomePage(context),
            tooltip: 'Share app',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App title section
              Text(
                'Deep Link Demo',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Firebase Dynamic Links Integration',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // Navigation buttons
              _buildNavigationSection(context),

              const SizedBox(height: 30),

              // Dynamic Link features
              _buildDynamicLinkSection(context),

              const SizedBox(height: 30),

              // Demo features
              _buildDemoSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Navigation', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile (Replace)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/details/sample_123'),
              child: const Text('Go to Details (Push)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/deeplink?source=homepage&data=abc'),
              child: const Text('Simulate Deep Link Nav'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicLinkSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dynamic Link Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _generateQuickShare(context),
              icon: const Icon(Icons.link),
              label: const Text('Generate Quick Share Link'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showDynamicLinkDemo(context),
              icon: const Icon(Icons.science),
              label: const Text('Dynamic Link Demo'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _generateBatchLinks(context),
              icon: const Icon(Icons.batch_prediction),
              label: const Text('Generate Batch Links'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Demo Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context),
              child: const Text('Show Dialog'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showCustomBottomSheet(context),
              child: const Text('Show Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate and share dynamic link for the home page
  Future<void> _shareHomePage(BuildContext context) async {
    try {
      final dynamicLink = DynamicLinkGenerator.generateHomeLink(
        analytics: CampaignPresets.socialShare,
      );

      await Clipboard.setData(ClipboardData(text: dynamicLink));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App link copied to clipboard!'),
            duration: Duration(seconds: 2),
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

  /// Generate a quick share link with analytics
  Future<void> _generateQuickShare(BuildContext context) async {
    final dynamicLink = DynamicLinkGenerator.generateCustomLink(
      path: '/details/quick_share_${DateTime.now().millisecondsSinceEpoch}',
      queryParams: {
        'utm_source': 'quick_share',
        'created_at': DateTime.now().toIso8601String(),
      },
      analytics: CampaignPresets.socialShare,
    );

    await Clipboard.setData(ClipboardData(text: dynamicLink));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Quick share link generated!\n${dynamicLink.substring(0, 50)}...',
          ),
          action: SnackBarAction(
            label: 'View Full',
            onPressed: () =>
                _showLinkDialog(context, dynamicLink, 'Quick Share Link'),
          ),
        ),
      );
    }
  }

  /// Show the dynamic link demo widget
  void _showDynamicLinkDemo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DynamicLinkDemo()),
    );
  }

  /// Generate multiple links at once
  Future<void> _generateBatchLinks(BuildContext context) async {
    final detailIds = ['item_1', 'item_2', 'item_3', 'item_4', 'item_5'];
    final links = DynamicLinkExamples.generateBatchLinks(detailIds);

    final linkText = links.join('\n\n');
    await Clipboard.setData(ClipboardData(text: linkText));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Generated ${links.length} links and copied to clipboard!',
          ),
          action: SnackBarAction(
            label: 'View All',
            onPressed: () =>
                _showLinkDialog(context, linkText, 'Batch Generated Links'),
          ),
        ),
      );
    }
  }

  /// Show generated link in a dialog
  void _showLinkDialog(BuildContext context, String link, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: SelectableText(
              link,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
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
                const SnackBar(content: Text('Links copied to clipboard!')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog.
  ///
  /// This dialog demonstrates an "on tap dialog navigation" experience.
  void _showConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Dialog Example'),
          content: const Text('This is a custom dialog invoked from a route.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action confirmed!')),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a custom bottom sheet.
  ///
  /// This bottom sheet demonstrates an "on tap bottomsheet navigation" experience.
  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('This is a custom bottom sheet.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Close Bottom Sheet'),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
