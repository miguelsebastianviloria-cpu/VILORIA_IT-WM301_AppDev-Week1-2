import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: const Text("Viloria, Miguel Sebastian D."),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BS Information Technology With Specialization in Web and Mobile Application Development"),
            Text("POCO F5"),
          ],
        ),
      ),
    );
  }
}
