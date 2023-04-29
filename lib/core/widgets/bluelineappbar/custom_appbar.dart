import 'package:blueline_contacts/core/widgets/bluelineappbar/controller/custom_appbar_controller.dart';
import 'package:blueline_contacts/core/widgets/bluelineappbar/state/custom_appbar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomAppBarState provider = ref.watch(customAppBarProvider);
    return AppBar(
      title: Text(provider.title),
      centerTitle: provider.centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
