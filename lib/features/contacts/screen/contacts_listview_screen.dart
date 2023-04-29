import 'package:blueline_contacts/features/contacts/controller/contacts_controller.dart';
import 'package:blueline_contacts/model/contact_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/bottomSheet/bottom_sheet.dart';
import 'listview_card.dart';

class ContactListView extends ConsumerStatefulWidget {
  const ContactListView({Key? key}) : super(key: key);

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  @override
  ConsumerState<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends ConsumerState<ContactListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('blueLineContactListView'),
      physics: const BouncingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: false,
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              ref
                  .watch(contactsControllerProvider)
                  .expansionList
                  .expansionItem[index]
                  .isExpanded = !isExpanded;
            });
          },
          children: ref
              .watch(contactsControllerProvider)
              .expansionList
              .expansionItem
              .map(
                (e) => ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return GestureDetector(
                      onLongPress: () {
                        if (!isExpanded) {
                          BlueLineUiElement.blShowModalBottomSheet(
                              context, e.data, ref);
                        }
                      },
                      key: PageStorageKey(
                          'blueLineContactListViewExpansionPanel${UniqueKey()}'),
                      child: ListTile(
                        key: PageStorageKey(
                            'blueLineContactListViewListTile1${UniqueKey()}'),
                        contentPadding: const EdgeInsets.only(left: 30),
                        title: Text('${e.data.firstName} ${e.data.lastName}'),
                        leading: CircleAvatar(
                          child: Text(e.data.firstName.substring(0, 1)),
                        ),
                      ),
                    );
                  },
                  body: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (ContactDetail detail in e.data.contactDetail!)
                            ListTileGenerator(
                              detail: detail,
                            ),
                          if (e.data.email != "")
                            ListTile(
                              key: PageStorageKey(
                                  'blueLineContactListViewListTile2${UniqueKey()}'),
                              leading: const Icon(
                                Icons.alternate_email,
                                color: Colors.blueAccent,
                              ),
                              title: Text(e.data.email),
                              onLongPress: () {
                                Clipboard.setData(
                                    ClipboardData(text: e.data.email));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                  ),
                                );
                              },
                              onTap: () {
                                widget._sendEmail(e.data.email);
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                  isExpanded: e.isExpanded,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
