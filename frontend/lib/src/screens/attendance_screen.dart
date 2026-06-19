import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendance = [
      {'day': 'السبت', 'status': 'حضر'},
      {'day': 'الأحد', 'status': 'حضر'},
      {'day': 'الاثنين', 'status': 'غائب'},
      {'day': 'الثلاثاء', 'status': 'حضر'},
      {'day': 'الأربعاء', 'status': 'حضر'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الحضور والغياب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('نسبة الحضور', style: TextStyle(fontSize: 16)),
                  Text('92%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: attendance.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = attendance[index];
                return ListTile(
                  title: Text(item['day']!),
                  trailing: Text(item['status']!,
                      style: TextStyle(
                        color: item['status'] == 'حضر' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
