import 'package:flutter/material.dart';

import '../services/user_api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Future<List<dynamic>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LPU Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary Statistics",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<dynamic>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Unable to load statistics"));
                }

                final users = snapshot.data ?? const <dynamic>[];
                final userRecords = users.whereType<Map<String, dynamic>>();
                final totalCompanies = userRecords
                    .map((user) => user['company'])
                    .whereType<Map<String, dynamic>>()
                    .map((company) => company['name'])
                    .whereType<String>()
                    .map((name) => name.trim())
                    .where((name) => name.isNotEmpty)
                    .toSet()
                    .length;
                final totalEmails = _countUsersWithValue(users, 'email');
                final totalContactNumbers = _countUsersWithValue(users, 'phone');

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _SummaryCard(
                      title: "Total Users",
                      value: "${users.length}",
                      icon: Icons.people_outline,
                    ),
                    _SummaryCard(
                      title: "Total Companies",
                      value: "$totalCompanies",
                      icon: Icons.business_outlined,
                    ),
                    _SummaryCard(
                      title: "Total Emails",
                      value: "$totalEmails",
                      icon: Icons.email_outlined,
                    ),
                    _SummaryCard(
                      title: "Total Contact Numbers",
                      value: "$totalContactNumbers",
                      icon: Icons.phone_outlined,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              "Programme Statistics",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _ProgrammeCard(code: "BSIT-NS", studentCount: 120),
                _ProgrammeCard(code: "BSIT-WM", studentCount: 150),
                _ProgrammeCard(code: "BSCS-DS", studentCount: 100),
                _ProgrammeCard(code: "BSCS-SE", studentCount: 90),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _countUsersWithValue(List<dynamic> users, String field) {
    return users.whereType<Map<String, dynamic>>().where((user) {
      final value = user[field];
      return value is String && value.trim().isNotEmpty;
    }).length;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgrammeCard extends StatelessWidget {
  const _ProgrammeCard({
    required this.code,
    required this.studentCount,
  });

  final String code;
  final int studentCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "$studentCount",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
