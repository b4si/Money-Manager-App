import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: (const Text('Reset all')),
            trailing: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            onTap: (() {}),
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: (() {}),
          )
        ],
      ),
    );
  }
}
