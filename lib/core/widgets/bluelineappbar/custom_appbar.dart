import 'package:blueline_contacts/features/contacts/controller/contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  CustomAppBar({super.key});
  Icon searchIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Contact Manager');
  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  final UniqueKey widgetKey = UniqueKey();
  final TextEditingController _searchController = TextEditingController();
  void _toggleSearch() {
    setState(() {
      if (widget.searchIcon.icon == Icons.search) {
        widget.searchIcon = const Icon(Icons.close);
        widget.searchBar = ListTile(
          leading: const Icon(
            Icons.search,
            color: Colors.white,
            size: 25,
          ),
          title: TextField(
            controller: _searchController,
            onChanged: (value) {
              _performSearch();
            },
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search contact..',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.normal,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        widget.searchIcon = const Icon(Icons.search);
        if (_searchController.text != '') {
          _searchController.text = '';
          _performSearch();
        }
        widget.searchBar = const Text('Contact Manager');
      }
    });
  }

  Future<void> _performSearch() async {
    ref
        .read(contactsControllerProvider.notifier)
        .searchContacts(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      _searchController.addListener(_performSearch);
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    return AppBar(title: widget.searchBar, centerTitle: true, actions: [
      IconButton(
        onPressed: () {
          _toggleSearch();
        },
        icon: widget.searchIcon,
      ),
      const SizedBox(
        width: 10,
      ),
    ]);
  }
}
