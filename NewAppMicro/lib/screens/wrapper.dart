import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/screens/auth/login_screen.dart';
import 'package:new_app_micro/screens/home/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // Return either Home or Login screen widget
    if (user == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
