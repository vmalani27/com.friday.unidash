// auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:http/http.dart';

// Define a service class for Google Sign-In
class GoogleAccountService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/classroom.courses.readonly'
  ]);

  Future<void> linkGoogleAccount(BuildContext context) async {
    String errorMessage = '';

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        errorMessage = 'Google Sign-In aborted by user';
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.currentUser!.linkWithCredential(credential);

      if (userCredential.user != null) {
        final profilePictureUrl = googleUser.photoUrl;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'linkedGmail': userCredential.user!.email,
          'profilePicture': profilePictureUrl,
        }, SetOptions(merge: true));

        // Create an AuthClient using the OAuth access token
        final authClient = authenticatedClient(
            Client(),
            AccessCredentials(
              AccessToken(
                  'Bearer',
                  googleAuth.accessToken!,
                  // Ensure that expiry is in UTC format
                  DateTime.now().toUtc().add(const Duration(hours: 1))),
              null,
              [
                'https://www.googleapis.com/auth/gmail.readonly',
                'https://www.googleapis.com/auth/classroom.courses.readonly'
              ],
            ));

        // Fetch user emails using Gmail API
        final gmailApi = GmailApi(authClient);
        var messages = await gmailApi.users.messages.list('me', maxResults: 10);
        print('Fetched Emails: ${messages.messages}');

        // Fetch user courses using Classroom API
        final classroomApi = ClassroomApi(authClient);
        var courses = await classroomApi.courses.list();
        print('Fetched Courses: ${courses.courses}');
      }

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/homescreen');
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'provider-already-linked') {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/homescreen');
        }
      } else {
        errorMessage = 'Failed to link Google account: $e';
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    }
  }
}
