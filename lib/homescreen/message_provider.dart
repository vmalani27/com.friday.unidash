// lib/homescreen/message_provider.dart

import 'package:flutter/foundation.dart';

class MessageProvider1 with ChangeNotifier {
  final List<Map<String, String>> _messages = [
    {'subject': 'Welcome', 'body': 'Welcome to Service 1'},
    // Add more messages
  ];

  List<Map<String, String>> get messages => _messages;
}

class MessageProvider2 with ChangeNotifier {
  final List<Map<String, String>> _messages = [
    {'subject': 'Update', 'body': 'Update from Service 2'},
    // More messages
  ];

  List<Map<String, String>> get messages => _messages;
}

class MessageProvider3 with ChangeNotifier {
  final List<Map<String, String>> _messages = [
    {'subject': 'Alert', 'body': 'Alert from Service 3'},
    // More messages
  ];

  List<Map<String, String>> get messages => _messages;
}
