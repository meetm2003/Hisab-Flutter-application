import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisab/custom_textfield.dart';
import 'package:hisab/loginScr.dart';

class RegisterScr extends StatelessWidget {
  RegisterScr({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginpasswordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _moneysaveController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _salarydateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              hint: 'Username',
              color: Colors.lightBlue,
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Phone Number',
              color: Colors.lightBlue,
              controller: _phonenumController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Email',
              color: Colors.lightBlue,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@gmail.com')) {
                  return 'Email must be @gmail.com';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Password',
              color: Colors.lightBlue,
              controller: _loginpasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'PIN',
              color: Colors.lightBlue,
              controller: _pinController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a PIN';
                }
                if (value.length != 4) {
                  return 'PIN must be 4 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Money Saved',
              color: Colors.lightBlue,
              controller: _moneysaveController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount saved';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Salary',
              color: Colors.lightBlue,
              controller: _salaryController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your salary';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Salary Date',
              color: Colors.lightBlue,
              controller: _salarydateController,
              isDatePicker: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),
            const SizedBox(height: 32), // Spacing before the button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Handle register logic
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
