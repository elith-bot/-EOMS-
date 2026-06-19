import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = [
      {'time': '08:00 - 09:00', 'subject': 'الرياضيات'},
      {'time': '09:15 - 10:15', 'subject': 'العربية'},
      {'time': '10:30 - 11:30', 'subject': 'العلوم'},
      {'time': '12:00 - 13:00', 'subject': 'اللغة الإنجليزية'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('جدول الدروس')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: schedule.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = schedule[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(item['subject']!),
                subtitle: Text(item['time']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
