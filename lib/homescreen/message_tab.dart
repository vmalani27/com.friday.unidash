// lib/homescreen/message_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_list.dart';
import 'message_provider.dart'; // Import your providers

class MessageTabs extends StatelessWidget {
  const MessageTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 88, 191, 230),
          automaticallyImplyLeading: false,
          title: const Text(
            'Uni-Dash',
            style: TextStyle(
              fontSize: 24, // Set the font size
              fontWeight: FontWeight.bold, // Set the font weight
              color: Colors.black, // Set the text color
              letterSpacing: 1.5, // Set letter spacing
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user-account');
              },
              icon: const Icon(Icons.account_box),
              color: Colors.black, // Optional: Set the icon color
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'WhatsApp'),
              Tab(text: 'Gmail'),
              Tab(text: 'Classroom'),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(
              255, 212, 209, 237), // Set the background color for the body
          child: TabBarView(
            children: [
              MessageList(serviceIndex: 1),
              MessageList(serviceIndex: 2),
              MessageList(serviceIndex: 3),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Define what happens when the button is pressed
          }, // Replace with the desired icon
          backgroundColor: Colors.blue,
          child: Icon(Icons.add), // Set the color of the FAB
        ),
      ),
    );
  }
}
