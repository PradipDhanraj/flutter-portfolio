import 'package:flutter/material.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class LocationInstructionsPage extends StatelessWidget {
  static String path = '/link-instructions';
  const LocationInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AnimatedLogo(iconSize: FontSizes.large * 2, rotate: true),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'How to Get Google Location Link',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: FontSizes.large,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _instructionStep('Open Google Maps in your web browser.'),
                _instructionStep('Search for the location you want.'),
                _instructionStep(
                  'Click the "Share" button (usually on the left panel or in the location info card).',
                ),
                _instructionStep('In the popup, click "Copy Link".'),
                _instructionStep('Paste the copied link into the app field.'),
                const SizedBox(height: 16),
                Text(
                  'Tip: You can also right-click on the map and select "What\'s here?" to get coordinates, then use the share button for a link.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FontSizes.small,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'How to Get Google Drive Folder Link & Allow Anyone to Upload:',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: FontSizes.large,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _instructionStep('Go to drive.google.com and log in.'),
                _instructionStep(
                  'Create a new folder or select an existing one.',
                ),
                _instructionStep(
                  'Right-click the folder and select "Get link".',
                ),
                _instructionStep(
                  'In the popup, change access from "Restricted" to "Anyone with the link".',
                ),
                _instructionStep(
                  'To allow uploads, click "Share", then "Settings" (gear icon), and enable "Editors can change permissions and share".',
                ),
                _instructionStep('6. Copy the link and share it with others.'),
                const SizedBox(height: 16),
                Text(
                  'Note: Anyone with the link can upload files if you set them as Editor. Use with caution!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FontSizes.small,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _instructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: Colors.white, fontSize: FontSizes.medium),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: FontSizes.medium),
            ),
          ),
        ],
      ),
    );
  }
}
