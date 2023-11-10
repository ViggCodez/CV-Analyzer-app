// settings.dart
import 'package:cvreimagined/screens/about.dart';
import 'package:cvreimagined/screens/contact.dart';
import 'package:cvreimagined/screens/premium.dart';
import 'package:cvreimagined/screens/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          // Logo
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child:
                Image.asset('assets/images/icon.png', width: 100, height: 100),
          ),

          // Version
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          // Setting Options
          buildSettingsCard('About Us', Icons.info, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsPage()),
            );
          }),
          buildSettingsCard('Contact Us', Icons.contact_mail, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsPage()),
            );
          }),
          buildSettingsCard('Premium', Icons.star, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PremiumPage()),
            );
          }),
          buildSettingsCard('Tutorial', Icons.school, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial()),
            );
          }),
          buildSettingsCard('Share App', Icons.share, () {
            _launchUrl();
          }),
        ],
      ),
    );
  }

  Card buildSettingsCard(String title, IconData icon, Function() onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: onTap,
      ),
    );
  }
}

final Uri _url = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.google.android.youtube');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
