import 'package:flutter/cupertino.dart';

@immutable
class CustomAppBarState {
  //constructor
  const CustomAppBarState(
      {this.title = 'Contacts Manager', this.centerTitle = true});

  CustomAppBarState copyWith({String? title, bool? centerTitle}) {
    return CustomAppBarState(
        title: title ?? this.title,
        centerTitle: centerTitle ?? this.centerTitle);
  }

  //fields
  final String title;
  final bool centerTitle;
}
