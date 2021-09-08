import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/models/providers/auth.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static String routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            // ignore: prefer_const_constructors
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
              colors: [
                Colors.red.withOpacity(.75),
                Colors.redAccent.withOpacity(.4),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: deviceSize.width * 0.2),
                    transform: Matrix4.rotationZ(-8 * pi / 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(-4, 8),
                        )
                      ],
                    ),
                    child: const Text(
                      'My Shop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Flexible(
                  // flex: 2,
                  child: AuthCard(),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

AuthMode _authMode = AuthMode.login;
// AuthMode _authMode = AuthMode.signup;

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final Map<String, String> _enteredData = {
    'email': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Container(
        // height: _authMode == AuthMode.login ? 230 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.login ? 230 : 280),
        width: deviceSize.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (newValue) {
                      _enteredData['email'] = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter Valid Email ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                    onSaved: (newValue) {
                      _enteredData['password'] = newValue!;
                    },
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Password must be 6 chatacter long';
                      }
                      return null;
                    },
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirm password'),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Password Not Match';
                        }
                      },
                      onChanged: (value) => _formKey.currentState!.validate(),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _authMode == AuthMode.login ? 'Login' : 'Sign Up'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(140, 40),
                      primary: Colors.red.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.login
                            ? AuthMode.signup
                            : AuthMode.login;
                      });
                    },
                    child: Text(_authMode == AuthMode.login
                        ? 'Sign Up Instead'
                        : 'Login Instead'),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_enteredData['email']!, _enteredData['password']!);
      }
      if (_authMode == AuthMode.signup) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_enteredData['email']!, _enteredData['password']!);
      }
    } on HttpException catch (error) {
      var _errorMessage = 'Authenication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        _errorMessage =
            'The email address is already in use by another account.';
      }
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        _errorMessage =
            'There is no user record corresponding to this identifier. The user may have been deleted.';
      }
      if (error.toString().contains('INVALID_PASSWORD')) {
        _errorMessage = 'The password is invalid';
      }
      if (error.toString().contains('USER_DISABLED')) {
        _errorMessage =
            'The user account has been disabled by an administrator.';
      }
      if (error.toString().contains('INVALID_EMAIL')) {
        _errorMessage = 'The email is invalid';
      }

      _showErrorDialog(_errorMessage);
    } catch (error) {
      var _errorMessage =
          'Your Authentication Can\'t be Processed Try Again Later';
      _showErrorDialog(_errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Authentication Failed !'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: const Text('Okey'),
            onPressed: () {
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }
}
