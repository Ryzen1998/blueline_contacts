import 'dart:io';

import 'package:blueline_contacts/core/widgets/profileImagePicker/profileImagePicker.dart';
import 'package:blueline_contacts/features/contacts/controller/contacts_controller.dart';
import 'package:blueline_contacts/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/contact_detail.dart';

class NewContactScreen extends ConsumerStatefulWidget {
  NewContactScreen({Key? key, required this.contact}) : super(key: key) {
    if (contact.contactDetail!.isEmpty) {
      contact.contactDetail?.add(ContactDetail.init());
    }
  }
  final Contact contact;
  @override
  ConsumerState<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends ConsumerState<NewContactScreen> {
  final _formKey = GlobalKey<FormState>();
  File? profileImage;
  _callback(File image) {
    if (image.path != '') {
      setState(() {
        profileImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Manager'),
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    ProfileImagePicker(
                      contactImagePath: widget.contact.imagePath ?? '',
                      callback: _callback,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      initialValue: widget.contact.firstName,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        icon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                        setState(() {
                          widget.contact.firstName = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: widget.contact.lastName,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.contact.lastName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        icon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: widget.contact.email,
                      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                      validator: (value) {
                        if (value != null && value != '') {
                          if (!value.contains('@') || value.contains(' ')) {
                            return 'Please enter a valid email';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                        setState(() {
                          widget.contact.email = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email_outlined),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 130,
                          child: TextFormField(
                            initialValue: widget.contact.contactDetail?[0].nick,
                            maxLength: 8,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z]')),
                            ],
                            validator: (value) {
                              if (widget.contact.contactDetail?[0].number !=
                                  '') {
                                if (value == '' || value == null) {
                                  return 'Invalid nick';
                                }
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                              setState(() {
                                widget.contact.contactDetail?[0].nick = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Nick Name',
                              icon: Icon(Icons.abc_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: 170,
                          child: TextFormField(
                            initialValue:
                                widget.contact.contactDetail?[0].number,
                            maxLength: 15,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[+0-9]')),
                            ],
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                              setState(() {
                                widget.contact.contactDetail?[0].number = value;
                              });
                            },
                            validator: (value) {
                              if (widget.contact.contactDetail?[0].nick != '') {
                                if (value == '' || value == null) {
                                  return 'Invalid phone number';
                                }
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              icon: Icon(Icons.phone_android_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              widget.contact.imagePath =
                  profileImage?.path ?? widget.contact.imagePath ?? '';
              ref
                  .read(contactsControllerProvider.notifier)
                  .addContact(widget.contact, profileImage ?? File(''));
            });
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
