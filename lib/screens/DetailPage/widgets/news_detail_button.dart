import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailButton extends StatelessWidget {
  final String? url;

  const NewsDetailButton({super.key, required this.url});

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (url.isEmpty) {
      debugPrint("URL is empty");
      return;
    }

    try {
      String processedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        processedUrl = 'https://$url';
      }

      final uri = Uri.parse(processedUrl);

      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
      await launchUrl(uri);
    } on PlatformException catch (e) {
      debugPrint("Platform error: $e");
      _showSnackBar(context, "Could not open the link: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
      _showSnackBar(context, "Could not open the link: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return const SizedBox();

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: FilledButton.tonal(
        onPressed: () => _launchUrl(context, url!),
        style: FilledButton.styleFrom(
          backgroundColor: isDarkMode
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.primary,
          foregroundColor: isDarkMode
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.open_in_new_rounded,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              'Read Full Article',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}