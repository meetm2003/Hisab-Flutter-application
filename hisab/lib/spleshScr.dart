import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hisab/hisabHomeScreen.dart';
import 'package:hisab/loginScr.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Simulate a delay for the splash screen (optional)
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, now check if there's a PIN in the database
      final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

      // Access the user's node in the database
      DataSnapshot snapshot = await _databaseRef
          .child('users')
          .child(user.uid)
          .child('pin')
          .get();

      if (snapshot.exists && snapshot.value != null) {
        // PIN exists, prompt the user to enter the PIN
        _showPinDialog(snapshot.value.toString());
      } else {
        // No PIN, navigate to HisabHomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Hisabhomescreen()),
        );
      }
    } else {
      // User is not signed in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  // Function to show a dialog for PIN entry
  void _showPinDialog(String correctPin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String enteredPin = '';
        return AlertDialog(
          title: const Text('Enter PIN'),
          content: TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              enteredPin = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your PIN',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (enteredPin == correctPin) {
                  // PIN is correct, navigate to HisabHomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Hisabhomescreen()),
                  );
                } else {
                  // PIN is incorrect, show an error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect PIN. Please try again.')),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
