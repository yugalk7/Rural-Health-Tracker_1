import 'package:flutter/material.dart';
import 'package:new_app_micro/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  String _selectedRole = 'Health Worker';
  bool loading = false;

  final List<String> _roles = ['Health Worker', 'Doctor', 'Admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Create an Account',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField(
                      initialValue: _selectedRole,
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedRole = val.toString()),
                      decoration:
                          const InputDecoration(labelText: 'Select Role'),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, _selectedRole);

                          if (!context.mounted) return;

                          if (result is String) {
                            setState(() {
                              error = result;
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
