import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'screens/signup_page.dart';
import 'screens/dashboard_page.dart';   // your main page

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passController = TextEditingController();

  String? error;

  void login() {

    var box = Hive.box('userBox');

    String? savedEmail = box.get('email');
    String? savedPassword = box.get('password');

    if (emailController.text == savedEmail &&
        passController.text == savedPassword) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );

    } else {

      setState(() {
        error = "Invalid email or password";
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEDF6F2),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                'Dwindle',
                style: TextStyle(
                  color: Color(0xFF339966),
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              if (error != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339966),
                  padding: EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 16,
                  ),
                ),
                child: Text('Login'),
              ),

              SizedBox(height: 16),

              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupPage()),
                  );

                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Color(0xFF339966)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}