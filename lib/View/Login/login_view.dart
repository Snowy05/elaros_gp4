import 'package:flutter/material.dart';
import 'package:elaros_gp4/Controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  void _handleLogin() async {
    bool success = await _authController.loginUser(
      _emailController.text,
      _passwordController.text,
      context,
    );

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 217, 130),
      body: Column(
        children: [
          const SizedBox(height: 200),
          const Text(
            'Welcome to Sleepy Fox',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/sign-up'),
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
