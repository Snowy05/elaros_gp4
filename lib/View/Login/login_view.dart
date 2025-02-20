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
      Navigator.pushReplacementNamed(context, '/WelcomeView');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 217, 130),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.asset('Assets/SleepyFoxLogo512.png', width: 150, height: 150),
            const SizedBox(height: 35),
            const Text(
              'Welcome to Sleepy Fox',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/ResetPassword'),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                side: const BorderSide(color: Colors.black, width: 0.5),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/Register'),
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
      ),
    );
  }
}
