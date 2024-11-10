import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/domain/auth_service.dart';
import 'package:newsbriefapp/presentation/widgets/components/auth/auth_text_field.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_alert.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/preloader.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/auth_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, String> _formData = {
    'email': '',
    'username': '',
    'password': '',
    'password_confirm': ''
  };
  bool _showPassword = false;
  bool _userExists = false;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  bool _isLoading = false;

  void showPasswordField() async {
    var res = await findUser(_formData);
    setState(() {
      _showPassword = true;
      _userExists = res;
    });
  }

  void handleFormData(String key, String value) {
    setState(() {
      _formData[key] = value;
    });
  }

  void handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (!_showPassword) {
      if (_formData['email']!.isNotEmpty) showPasswordField();
      return;
    }
    if (_formData['email']!.isEmpty ||
        _formData['password']!.isEmpty ||
        (!_userExists && _formData['password_confirm']!.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomAlert('Please check the passwords!'));
      return;
    }
    if (!_userExists &&
        _formData['password'] != _formData['password_confirm']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomAlert('Passwords do not match!'));
      return;
    }
    Map<String, dynamic> response;
    if (_userExists) {
      response = await loginRequest(_formData);
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomAlert('User logged in successfully!'));
    } else {
      response = await registerRequest(_formData);
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomAlert('User registered successfully!'));
    }
    setState(() {
      _isLoading = false;
    });
    if (response['success']) {
      String token = response['token'];
      String user = jsonEncode(response['user']).toString();
      tokenStorage.saveString(token);
      userStorage.saveString(user);
      Navigator.pushNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomAlert('Some error occurred please try again!'));
    }
  }

  void handleSocialLogin() async {
    setState(() {
      _isLoading = true;
    });
    var response = await signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    if (response['success']) {
      String token = response['token'];
      String user = jsonEncode(response['user']).toString();
      tokenStorage.saveString(token);
      userStorage.saveString(user);
      Navigator.pushNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomAlert('Some error occurred please try again!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    'https://newsbriefapp.com/assets/logo.jpg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Preloader()
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    'https://newsbriefapp.com/assets/logo.jpg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Text(!_showPassword
                      ? 'Log in or sign up with email'
                      : _userExists
                          ? 'Welcome back'
                          : 'Finish signing up'),
                  const SizedBox(
                    height: 48,
                  ),
                  AuthTextField(
                    label: 'Email',
                    onTextChanged: (value) => handleFormData('email', value),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  if (_showPassword && !_userExists)
                    AuthTextField(
                      label: 'Usernname',
                      onTextChanged: (value) =>
                          handleFormData('username', value),
                    ),
                  if (_showPassword && !_userExists)
                    const SizedBox(
                      height: 48,
                    ),
                  if (_showPassword)
                    AuthTextField(
                      secured: true,
                      label: 'Password',
                      onTextChanged: (value) =>
                          handleFormData('password', value),
                    ),
                  if (_showPassword)
                    const SizedBox(
                      height: 48,
                    ),
                  if (_showPassword && !_userExists)
                    AuthTextField(
                      secured: true,
                      label: 'Confirm Password',
                      onTextChanged: (value) =>
                          handleFormData('password_confirm', value),
                    ),
                  if (_showPassword && !_userExists)
                    const SizedBox(
                      height: 48,
                    ),
                  if (_showPassword && !_userExists)
                    Text(
                      'By continuing, you agree to our Terms of Use and Privacy Policy.',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  if (_showPassword && !_userExists)
                    const SizedBox(
                      height: 8,
                    ),
                  IconButton(
                      onPressed: handleSubmit,
                      icon: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: Center(
                          child: Text(
                            _showPassword
                                ? _userExists
                                    ? 'Login'
                                    : 'Agree and continue'
                                : 'Continue',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Or',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  IconButton(
                      onPressed: handleSocialLogin,
                      icon: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Continue with Google',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Continue with Facebook',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.apple,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Continue with Apple Id',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ))
                ],
              ));
  }
}
