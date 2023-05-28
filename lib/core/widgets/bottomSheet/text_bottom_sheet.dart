import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlueLineTextBottomSheet {
  static Future<void> _sendSms(String phoneNumber) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(smsLaunchUri);
  }

  static Future<void> _openWhatsapp(String phoneNumber) async {
    final url = 'whatsapp://send?phone=+$phoneNumber';
    if (await canLaunchUrlString('whatsapp://')) {
      await launchUrlString(url);
    } else {
      await launchUrlString(url);
    }
  }

  static void blShowTextBottomSheet(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.message,
                color: Colors.blueAccent,
              ),
              title: const Text('Text'),
              onTap: () {
                _sendSms(phoneNumber);
              },
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green,
              ),
              title: const Text('Whatsapp'),
              onTap: () {
                _openWhatsapp(phoneNumber);
              },
            ),
          ],
        );
      },
    );
  }
}
