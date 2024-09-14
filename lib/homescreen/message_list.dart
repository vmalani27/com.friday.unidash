// lib/homescreen/message_list.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart'; // Ensure this import is correct

class MessageList extends StatelessWidget {
  final int serviceIndex;

  const MessageList({super.key, required this.serviceIndex});

  @override
  Widget build(BuildContext context) {
    // Define a map to associate serviceIndex with the corresponding provider
    final Map<int, ChangeNotifier> providers = {
      1: Provider.of<MessageProvider1>(context),
      2: Provider.of<MessageProvider2>(context),
      3: Provider.of<MessageProvider3>(context),
    };

    // Get the appropriate provider based on serviceIndex
    final messageProvider = providers[serviceIndex];

    if (messageProvider == null) {
      return const Center(
          child: Text('No messages available for this service.'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: (messageProvider as dynamic).messages.length,
        itemBuilder: (context, index) {
          final message = (messageProvider as dynamic).messages[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                message['subject'] ?? 'No Subject',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(message['body'] ?? 'No Content'),
            ),
          );
        },
      ),
    );
  }
}
