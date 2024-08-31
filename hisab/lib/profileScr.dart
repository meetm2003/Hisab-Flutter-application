import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hisab/custom_textfield.dart';
import 'package:hisab/loginScr.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  bool _isEditing = false;

  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _salaryController;
  late TextEditingController _salaryDateController;
  late TextEditingController _pinController;
  late TextEditingController _moneyYouHaveController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _salaryController = TextEditingController();
    _salaryDateController = TextEditingController();
    _pinController = TextEditingController();
    _moneyYouHaveController = TextEditingController();

    // Fetch user data and set up controllers
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    if (_user != null) {
      final userSnapshot = await _userRef.child(_user!.uid).get();

      final userData = userSnapshot.value as Map<dynamic, dynamic>;

      // Update controllers with fetched user data
      _usernameController.text = userData['username'] ?? '';
      _phoneController.text = userData['phone'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _salaryController.text = userData['salary'] ?? '';
      _salaryDateController.text = userData['salary_date'] ?? '';
      _pinController.text = userData['pin'] ?? '';
      _moneyYouHaveController.text = userData['money_you_have'] ?? '';

      setState(() {});
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_user != null) {
      await _userRef.child(_user!.uid).update({
        'username': _usernameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'salary': _salaryController.text,
        'salary_date': _salaryDateController.text,
        'pin': _pinController.text,
        'money_you_have': _moneyYouHaveController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      _toggleEditMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isEditing ? _buildEditForm() : _buildProfileDetails(),
            if (!_isEditing) ...[
              const SizedBox(height: 20),
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
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileRow('Username:', _usernameController.text),
        _buildProfileRow('Phone:', _phoneController.text),
        _buildProfileRow('Email:', _emailController.text),
        _buildProfileRow('Salary:', _salaryController.text),
        _buildProfileRow('Salary Date:', _salaryDateController.text),
        _buildProfileRow('PIN:', _pinController.text),
        _buildProfileRow('Money You Have:', _moneyYouHaveController.text),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hint: 'Username',
          color: Colors.blue,
          controller: _usernameController,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'Phone',
          color: Colors.blue,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'Email',
          color: Colors.blue,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'Salary',
          color: Colors.blue,
          controller: _salaryController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'Salary Date',
          color: Colors.blue,
          controller: _salaryDateController,
          isDatePicker: true,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'PIN',
          color: Colors.blue,
          controller: _pinController,
          isPassword: true,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'Money You Have',
          color: Colors.blue,
          controller: _moneyYouHaveController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
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
              _saveChanges();
            },
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
