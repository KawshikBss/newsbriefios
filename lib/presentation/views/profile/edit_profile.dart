import 'dart:convert';
import 'dart:io';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_alert.dart';
import 'package:newsbriefapp/presentation/widgets/components/profile/profile_text_field.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/menu_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  String? _token;
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  Map<String, String> _userData = {
    'name': '',
    'username': '',
    'website': '',
    'bio': '',
    'email': ''
  };
  File? _avatar;

  void handleChange(String key, String value) {
    setState(() {
      _userData[key] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    tokenStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      setState(() {
        _token = value;
      });
    });
    userStorage.readString().then((value) {
      if (value.isEmpty) return;
      var data = jsonDecode(value) as Map<String, dynamic>;
      setState(() {
        _userData = {
          'avatar': data['avatar'] ?? '',
          'name': data['name'] ?? '',
          'username': data['username'] ?? '',
          'website': data['website'] ?? '',
          'bio': data['bio'] ?? '',
          'email': data['email'] ?? ''
        };
      });
    });
  }

  void handleSubmit() async {
    var res = await updateProfile(_token, _userData, _avatar);
    if (res['success']) {
      var data = res['user'];
      setState(() {
        _userData = {
          'avatar': data['avatar'] ?? '',
          'name': data['name'] ?? '',
          'username': data['username'] ?? '',
          'website': data['website'] ?? '',
          'bio': data['bio'] ?? '',
          'email': data['email'] ?? ''
        };
      });
      String user = jsonEncode(data).toString();
      userStorage.saveString(user);
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomAlert('Profile updated successfully!'));
      Navigator.pop(context);
    }
  }

  void handleImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatar = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuLayout(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(200),
                            image: DecorationImage(
                                image: _avatar != null
                                    ? FileImage(_avatar!)
                                    : NetworkImage(
                                        _userData['avatar'] != null &&
                                                _userData['avatar']!.isNotEmpty
                                            ? 'https://newsbriefbucket.s3.us-east-2.amazonaws.com/${_userData['avatar']}'
                                            : 'https://ircsan.com/wp-content/uploads/2024/03/placeholder-image.png',
                                      ),
                                fit: BoxFit.cover))),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: handleImage,
                            icon: const Icon(FontAwesomeIcons.image)))
                  ],
                ),
                const SizedBox(
                  height: 48,
                ),
                ProfileTextField(
                  label: AppLocalizations.of(context)?.name ?? 'Name',
                  value: _userData['name'] ?? '',
                  onTextChanged: (value) => handleChange('name', value),
                ),
                const SizedBox(
                  height: 16,
                ),
                ProfileTextField(
                  label: AppLocalizations.of(context)?.username ?? 'Username',
                  value: _userData['username'] ?? '',
                  onTextChanged: (value) => handleChange('username', value),
                ),
                const SizedBox(
                  height: 16,
                ),
                ProfileTextField(
                  label: AppLocalizations.of(context)?.website ?? 'Website',
                  value: _userData['website'] ?? '',
                  onTextChanged: (value) => handleChange('website', value),
                ),
                const SizedBox(
                  height: 16,
                ),
                ProfileTextField(
                  label: AppLocalizations.of(context)?.bio ?? 'Bio',
                  value: _userData['bio'] ?? '',
                  onTextChanged: (value) => handleChange('bio', value),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context)?.privateInfo ??
                      'Private info (only visible to you)'),
                ),
                const SizedBox(
                  height: 16,
                ),
                ProfileTextField(
                  label: AppLocalizations.of(context)?.email ?? 'Email',
                  value: _userData['email'] ?? '',
                  disabled: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                IconButton(
                    onPressed: handleSubmit,
                    icon: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF0d6efd)),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)?.save ?? 'Save',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ))
              ],
            )));
  }
}
