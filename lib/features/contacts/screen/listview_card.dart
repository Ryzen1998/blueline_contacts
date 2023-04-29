import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/contact_detail.dart';

class ListTileGenerator extends StatefulWidget {
  const ListTileGenerator({
    super.key,
    required this.detail,
  });
  final ContactDetail detail;
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendSms(String phoneNumber) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(smsLaunchUri);
  }

  @override
  State<ListTileGenerator> createState() => _ListTileGeneratorState();
}

class _ListTileGeneratorState extends State<ListTileGenerator> {
  bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Icon _setPhoneIcon() {
    if (_hasCallSupport) {
      return const Icon(
        Icons.phone_android_sharp,
        color: Colors.blueAccent,
      );
    }
    return const Icon(
      Icons.phonelink_erase_sharp,
      color: Colors.redAccent,
    );
  }

  MaterialAccentColor _setIconColor() {
    if (_hasCallSupport) {
      return Colors.blueAccent;
    }
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.detail.number != '')
          SizedBox(
            child: Container(
              padding: const EdgeInsets.only(left: 17),
              height: 50,
              child: Row(
                children: [
                  _setPhoneIcon(),
                  const SizedBox(
                    width: 28,
                  ),
                  InkWell(
                    onLongPress: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.detail.number));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Text(
                          widget.detail.number,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      color: _setIconColor(),
                    ),
                    onPressed: () {
                      if (_hasCallSupport) {
                        widget._makePhoneCall(widget.detail.number);
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      color: _setIconColor(),
                    ),
                    onPressed: () {
                      if (_hasCallSupport) {
                        widget._sendSms(widget.detail.number);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
