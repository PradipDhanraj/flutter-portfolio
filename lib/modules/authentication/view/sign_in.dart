import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class SignInPage extends StatefulWidget {
  static String path = '/login';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    final (user, error) = await DI.authService.signInWithGoogle();
    setState(() => _loading = false);
    if (user != null) {
      GoRouter.of(context).pop((true, user));
    } else {
      SnackbarUtils.showSnackBar(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            _loading
                ? const AnimatedLogo(
                  color: Colors.white,
                  iconSize: 30,
                  rotate: true,
                )
                : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(220, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                  ),
                  icon: Icon(
                    Icons.abc, // Place your Google logo asset here
                    size: 24,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: _handleGoogleSignIn,
                ),
      ),
    );
  }
}
