import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'setup_page.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  /// ---------------- VALIDATION ----------------

  bool isValidName(String name) {
    return name.trim().length >= 3;
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }


  bool isValidEmail(String email) {
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return gmailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final passwordRegex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// ---------------- SIGNUP ----------------

  void signup() {

    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {

      showError("Please fill all fields");
      return;
    }

    if (!isValidName(name)) {
      showError("Name must be at least 3 characters");
      return;
    }

    if (!isValidPhone(phone)) {
      showError("Phone must be exactly 10 digits");
      return;
    }

    if (!isValidEmail(email)) {
      showError("Enter a valid email address (example@gmail.com)");
      return;
    }

    if (!isValidPassword(password)) {
      showError(
          "Password must be 8+ chars with letter, number & special char");
      return;
    }

    var box = Hive.box('userBox');

    box.put('name', name);
    box.put('phone', phone);
    box.put('email', email);
    box.put('password', password);
    box.put('isLoggedIn', true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup successful")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SetupPage()),
    );
  }

  /// ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Color(0xFF339966),
      ),

      body: Padding(
        padding: EdgeInsets.all(24),

        child: SingleChildScrollView(
          child: Column(
            children: [

              /// NAME
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Enter Name",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              /// PHONE
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[5-9][0-9]*'),
                  ),
                ],

                decoration: const InputDecoration(

                  labelText: "Enter Phone Number",

                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),

              SizedBox(height: 20),

              /// EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              /// PASSWORD
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),

              /// BUTTON
              ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339966),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: Text("Create Account"),
              )

            ],
          ),
        ),
      ),
    );
  }
}