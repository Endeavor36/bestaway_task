import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

enum AuthMode { signUp, login }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.login;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;

  _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  _submit() {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_authMode == AuthMode.login) {
        context.read<AuthProvider>().signIn(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              context,
            );
      } else {
        context.read<AuthProvider>().signUp(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              context,
            );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bestaway',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must contain atleast 6 characters.';
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: _authMode == AuthMode.signUp,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        } else if (value != _passwordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _switchAuthMode,
                      child: _authMode == AuthMode.login
                          ? const Text('Want to Sign Up?')
                          : const Text('Already signed up?'),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submit,
                            child: _authMode == AuthMode.login
                                ? const Text('Login')
                                : const Text('Sign Up'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
