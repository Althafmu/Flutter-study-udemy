import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

var _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogedin = true;
  var _email = '';
  var _password = '';
  var _username = '';
  File? _pickedImage;
  bool _isloading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || (_pickedImage == null && !_isLogedin)) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isloading = true;
      });

      if (_isLogedin) {
        await _firebase.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // ✅ Ensure the picked image exists
        if (_pickedImage == null || !_pickedImage!.existsSync()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid image selected')),
          );
          setState(() {
            _isloading = false;
          });
          print('No valid image selected');
          return;
        }

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_pickedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
              'username': _username,
              'email': _email,
              'image_url': imageUrl,
            });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 0,
                  left: 20,
                  right: 20,
                ),
                width: 300,
                child: Image.asset('assets/images/chat.png', fit: BoxFit.fill),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogedin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _pickedImage = pickedImage;
                              },
                            ),
                          if (!_isLogedin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _username = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return 'please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'please enter atleast 6 characters';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _password = newValue!;
                            },
                          ),
                          SizedBox(height: 12),
                          if (_isloading) CircularProgressIndicator(),
                          if (!_isloading)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                              ),
                              child: Text(_isLogedin ? 'login' : 'Signup'),
                            ),
                          if (!_isloading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogedin = !_isLogedin;
                                });
                              },
                              child: Text(
                                _isLogedin
                                    ? 'create an account'
                                    : 'already have an account',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
