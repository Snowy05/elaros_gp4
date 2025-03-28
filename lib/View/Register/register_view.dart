import 'package:flutter/material.dart';
import 'package:elaros_gp4/Controller/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController(); // Uses controller

  void _handleSignUp() async {
    bool success = await _authController.signUp(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      context, // Pass context for navigation/snackbar
    );

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/Dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 255, 132, 0),
              Color.fromARGB(255, 255, 171, 81),
              Color.fromARGB(255, 255, 215, 134),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/SleepyFoxLogo512.png',
                    width: 150, height: 150),
                const SizedBox(height: 35),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 300, // Set the desired width here
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
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 300, // Set the desired width here
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
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    side: const BorderSide(color: Colors.black, width: 0.5),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/Login'),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
