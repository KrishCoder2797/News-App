import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isPressd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/p_logo.png",
                height: 200,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Welcome to PNews!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Our mission is to provide you with accurate, timely, and comprehensive news, helping you stay informed and connected with the world around you.',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Our History',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'PNews was created in 2024 by Prasad Zadokar, a third-year student with a passion for App development and technology. This project was developed using Flutter, a powerful framework for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. ',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Meet Our Team',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Text('PZ'), // Initials of Prasad Zadokar
              ),
              title: Text('Prasad Zadokar'),
              subtitle: Text('Developer'),
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Text('SD'), // Initials of John Smith
              ),
              title: Text('Srushti Dadas'),
              subtitle: Text('Tech Support'),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('prasadzadokar25@gmail.com'),
              onTap: () {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'prasadzadokar25@gmail.com',
                );
                _launchApp(url: emailUri.toString());
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: const Text('+91 8956652382'),
              onTap: () {
                final Uri _phoneLaunchUri = Uri(
                  scheme: 'tel',
                  path: '+918956652382',
                );
                _launchApp(url: _phoneLaunchUri.toString());
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Feedback',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat with Us'),
              onTap: () {
                final Uri whatsappUri = Uri(
                  scheme: 'https',
                  host: 'wa.me',
                  path: '/+918956652382',
                );
                _launchApp(url: whatsappUri.toString());
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Leave Feedback'),
              onTap: () {
                final Uri feedbackUri = Uri(
                  scheme: 'mailto',
                  path: 'pnews.prasadzadokar@gmail.com',
                  queryParameters: {'subject': 'Feedback for PNews App'},
                );
                _launchApp(url: feedbackUri.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _launchApp({required String url}) async {
  const fallbackUrl =
      'https://www.instagram.com/_prasadpatil.?igsh=MTV5ZXF1bnVsdjlkZA==';

  try {
    bool launched =
        await launch(url, forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  }
}
