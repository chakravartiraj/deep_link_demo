import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dynamic_link_generator.dart';

/// Configuration and setup guide for Firebase Dynamic Links
class DynamicLinkSetupPage extends StatelessWidget {
  const DynamicLinkSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Link Setup'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 20),
            _buildConfigurationSection(context),
            const SizedBox(height: 20),
            _buildTestSection(context),
            const SizedBox(height: 20),
            _buildExamplesSection(context),
            const SizedBox(height: 20),
            _buildSetupInstructionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, size: 32, color: Colors.blue[700]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Firebase Dynamic Links Integration',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Generate and share dynamic links for your Flutter app pages. '
                        'Currently configured for Android platform.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildConfigItem(
              'Dynamic Link Domain',
              DynamicLinkGenerator.dynamicLinkDomain,
              'Replace with your Firebase domain',
              Colors.orange,
            ),
            _buildConfigItem(
              'Android Package',
              DynamicLinkGenerator.androidPackage,
              'Matches your app\'s package name',
              Colors.green,
            ),
            _buildConfigItem(
              'Web Base URL',
              DynamicLinkGenerator.webBaseUrl,
              'Your GitHub Pages URL',
              Colors.blue,
            ),
            _buildConfigItem(
              'Min Android Version',
              DynamicLinkGenerator.minimumAndroidVersionCode.toString(),
              'API level 21 (Android 5.0+)',
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(
    String label,
    String value,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(value, style: const TextStyle(fontFamily: 'monospace')),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Dynamic Link Generation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Test buttons for each page type
            _buildTestButton(
              context,
              'Generate Home Link',
              Icons.home,
              () => _testHomeLink(context),
            ),
            _buildTestButton(
              context,
              'Generate Details Link (ID: test123)',
              Icons.description,
              () => _testDetailsLink(context, 'test123'),
            ),
            _buildTestButton(
              context,
              'Generate Profile Link',
              Icons.person,
              () => _testProfileLink(context),
            ),
            _buildTestButton(
              context,
              'Generate Report Link (ID: report456)',
              Icons.assignment,
              () => _testReportLink(context, 'report456'),
            ),
            _buildTestButton(
              context,
              'Generate QR Code Link',
              Icons.qr_code,
              () => _testQrCodeLink(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
        ),
      ),
    );
  }

  Widget _buildExamplesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Examples',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'In your Flutter pages, add sharing functionality like this:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SelectableText(
                '''// Generate a dynamic link for a details page
final dynamicLink = DynamicLinkGenerator.generateDetailsLink(
  detailId: 'item123',
  queryParams: {'utm_source': 'app_share'},
  analytics: CampaignPresets.socialShare,
);

// Copy to clipboard
await Clipboard.setData(ClipboardData(text: dynamicLink));''',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupInstructionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setup Instructions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSetupStep(
              '1. Configure Firebase Dynamic Links',
              'Update the domain in DynamicLinkGenerator to your Firebase project domain',
            ),
            _buildSetupStep(
              '2. Update Package Name',
              'Ensure androidPackage matches your app\'s actual package name',
            ),
            _buildSetupStep(
              '3. Configure Web URL',
              'Set webBaseUrl to your deployed GitHub Pages URL',
            ),
            _buildSetupStep(
              '4. Test Links',
              'Use the test buttons above to verify link generation works',
            ),
            _buildSetupStep(
              '5. Add to Pages',
              'Integrate share buttons in your existing pages using the examples',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 16, color: Colors.blue[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Test methods
  Future<void> _testHomeLink(BuildContext context) async {
    final link = DynamicLinkGenerator.generateHomeLink(
      analytics: CampaignPresets.socialShare,
    );
    await _copyAndShowLink(context, 'Home Link', link);
  }

  Future<void> _testDetailsLink(BuildContext context, String detailId) async {
    final link = DynamicLinkGenerator.generateDetailsLink(
      detailId: detailId,
      queryParams: {'test': 'true', 'source': 'setup_page'},
      analytics: CampaignPresets.socialShare,
    );
    await _copyAndShowLink(context, 'Details Link', link);
  }

  Future<void> _testProfileLink(BuildContext context) async {
    final link = DynamicLinkGenerator.generateProfileLink(
      analytics: CampaignPresets.socialShare,
    );
    await _copyAndShowLink(context, 'Profile Link', link);
  }

  Future<void> _testReportLink(BuildContext context, String reportId) async {
    final link = DynamicLinkGenerator.generateReportLink(
      reportId: reportId,
      queryParams: {'status': 'active', 'test': 'true'},
      analytics: CampaignPresets.socialShare,
    );
    await _copyAndShowLink(context, 'Report Link', link);
  }

  Future<void> _testQrCodeLink(BuildContext context) async {
    final link = DynamicLinkGenerator.generateCustomLink(
      path: '/deeplink',
      queryParams: {'source': 'qr_code', 'campaign': 'test'},
      analytics: CampaignPresets.qrCode,
    );
    await _copyAndShowLink(context, 'QR Code Link', link);
  }

  Future<void> _copyAndShowLink(
    BuildContext context,
    String title,
    String link,
  ) async {
    await Clipboard.setData(ClipboardData(text: link));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title generated and copied!'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _showLinkDialog(context, title, link),
          ),
        ),
      );
    }
  }

  void _showLinkDialog(BuildContext context, String title, String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(maxHeight: 200),
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
                const SnackBar(content: Text('Link copied to clipboard!')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
