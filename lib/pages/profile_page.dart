import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../dynamic_link_generator.dart';

/// A simple profile page.
class ProfilePage extends StatelessWidget {
  /// Constructs a [ProfilePage].
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareProfile(context),
            tooltip: 'Share profile',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Profile avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),

            Text(
              'Your Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),

            // Profile info card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text('user@example.com'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text('+1 (555) 123-4567'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Location'),
                      subtitle: Text('San Francisco, CA'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // Changed from context.pop() to context.go('/') to prevent "nothing to pop" error
                  // when ProfilePage is reached via context.go() from HomePage.
                  onPressed: () => context.go('/'),
                  child: const Text('Go Back'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _shareProfile(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generate and share dynamic link for the profile page
  Future<void> _shareProfile(BuildContext context) async {
    try {
      // Generate dynamic link for profile
      final dynamicLink = DynamicLinkGenerator.generateProfileLink(
        queryParams: {
          'shared_at': DateTime.now().millisecondsSinceEpoch.toString(),
          'utm_content': 'profile_share',
        },
        analytics: CampaignPresets.socialShare,
      );

      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: dynamicLink));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile link copied to clipboard!'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View Link',
              onPressed: () => _showLinkDialog(context, dynamicLink),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating profile link: $e')),
        );
      }
    }
  }

  /// Show the generated link in a dialog
  void _showLinkDialog(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Dynamic Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this link to let others view your profile:'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Link copied!')));
            },
            child: const Text('Copy Again'),
          ),
        ],
      ),
    );
  }
}
