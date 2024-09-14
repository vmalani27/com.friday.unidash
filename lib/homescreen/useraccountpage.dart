import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_trial_2/auth/firebase/auth_service.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> _getUserDetails() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  bool _isGoogleAccountLinked() {
    return user?.providerData
            .any((provider) => provider.providerId == 'google.com') ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Account Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 88, 191, 230),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _signOut(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Whatsapp'),
              Tab(text: 'Gmail'),
              Tab(text: 'Classroom'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user data available'));
            } else {
              var userDetails = snapshot.data!;
              bool isGoogleLinked = _isGoogleAccountLinked();

              // Fetch profile picture from Google account or Firestore
              String profilePictureUrl = user?.photoURL ??
                  (userDetails['profilePicture'] ??
                      'https://via.placeholder.com/150'); // Use placeholder if null

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: const Color.fromARGB(255, 236, 235, 239),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(profilePictureUrl),
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${userDetails['firstName']} ${userDetails['lastName']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${user!.email ?? 'Not Provided'}',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Branch: ${userDetails['branch'] ?? 'Not Provided'}',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Semester: ${userDetails['semester'] ?? 'Not Provided'}',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            if (isGoogleLinked) ...[
                              ElevatedButton(
                                onPressed: () => _unlinkGoogleAccount(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                ),
                                child: Text('Unlink Google Account'),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your Google account is linked.',
                                style: TextStyle(color: Colors.green),
                              ),
                            ] else ...[
                              ElevatedButton(
                                onPressed: () => linkGoogleAccount(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                ),
                                child: Text('Link Google Account'),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'No Google account is linked.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTabContent('Gmail'),
                        _buildTabContent('Classroom'),
                        _buildTabContent('WhatsApp'),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(String service) {
    if (service == 'Gmail') {
      // Check if the user has already linked their Google account
      bool isGoogleLinked = _isGoogleAccountLinked();

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage your $service account link.',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (isGoogleLinked) ...[
              ElevatedButton(
                onPressed: () => _unlinkGoogleAccount(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('Unlink Google Account'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Google account is linked.',
                style: TextStyle(color: Colors.green),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () => linkGoogleAccount(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('Link Google Account'),
              ),
              const SizedBox(height: 8),
              const Text(
                'No Google account is linked.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Link your $service account here.',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> linkGoogleAccount(BuildContext context) async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Attempt to link the credential to the current user
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google account linked successfully')),
      );

      // Reload the page to reflect changes
      Navigator.pushReplacementNamed(context, '/user-account');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        try {
          // Get the existing user linked with this credential
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(e.credential!);

          // Link the existing account to the current user
          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(e.credential!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Account linked successfully after resolving conflict')),
          );

          // Reload the page to reflect changes
          Navigator.pushReplacementNamed(context, '/user-account');
        } catch (linkError) {
          print("Error linking Google account: $linkError");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to link Google account: $linkError')),
          );
        }
      } else {
        print("Error linking Google account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to link Google account: $e')),
        );
      }
    }
  }

  Future<void> _unlinkGoogleAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.unlink('google.com');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'linkedGmail': FieldValue.delete(),
        'profilePicture': FieldValue.delete(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google account unlinked successfully')),
      );

      // Reload the page to reflect changes
      Navigator.pushReplacementNamed(context, '/user-account');
    } on FirebaseAuthException catch (e) {
      print("Error unlinking Google account: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unlink Google account: $e')),
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }
}
