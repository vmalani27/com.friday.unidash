// userdetails.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart'; // Import the new auth service file

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  String _errorMessage = '';
  final GoogleAccountService _googleAccountService =
      GoogleAccountService(); // Use the service class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _rollNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _semesterController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  // Method to safely call setState if the widget is still mounted
  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  void _saveDetails() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _semesterController.text.isEmpty ||
        _branchController.text.isEmpty) {
      _safeSetState(() {
        _errorMessage = 'Please fill in all fields';
      });
    } else {
      _safeSetState(() {
        _errorMessage = '';
      });

      // Show a notice that the details are being saved
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving details and linking Google account...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Save user details to Firestore
      User? user = _auth.currentUser;
      if (user != null) {
        final String? photoURL =
            user.photoURL; // Check for the photo URL from the user object

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'rollNumber': _rollNumberController.text.trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'semester': _semesterController.text.trim(),
          'branch': _branchController.text.trim(),
          'email': user.email,
          'profilePicture':
              photoURL ?? '', // Use an empty string if the photoURL is null
          'apiIntegrationStatus':
              'pending', // Initial status for API integration
          'integrationDetails': {
            'integrationType': 'Google', // Example detail
            'integrationToken': null, // Placeholder for future token
            'integrationDate': Timestamp.fromDate(
                DateTime.now().toUtc()), // Correctly formatted date
          },
        });

        // Wait for the notice to be dismissed
        await Future.delayed(const Duration(seconds: 2));

        // Proceed to link Google account
        _googleAccountService
            .linkGoogleAccount(context); // Use the service class
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 600), // Limit max width if needed
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'User Details',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _rollNumberController,
                    decoration: InputDecoration(
                      labelText: 'Roll Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _semesterController,
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _branchController,
                    decoration: InputDecoration(
                      labelText: 'Branch',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveDetails,
                    child: const Text('Save Details'),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
