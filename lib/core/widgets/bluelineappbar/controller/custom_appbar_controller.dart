import 'package:blueline_contacts/core/widgets/bluelineappbar/state/custom_appbar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customAppBarProvider = StateNotifierProvider.autoDispose<
    CustomAppBarController, CustomAppBarState>((ref) {
  return CustomAppBarController(const CustomAppBarState());
});

class CustomAppBarController extends StateNotifier<CustomAppBarState> {
  CustomAppBarController(CustomAppBarState state) : super(state);

  void changeTitleText(String text) {
    state = state.copyWith(title: text);
  }
}
