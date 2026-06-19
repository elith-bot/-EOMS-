import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final dateString = DateFormat.yMMMMd('ar').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مرحباً ${user?.fullName ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(dateString, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildInfoCard('الدرجات', '85%', Icons.grade, Colors.blue),
              _buildInfoCard('الحضور', '92%', Icons.check_circle, Colors.green),
              _buildInfoCard('الأقساط', '5000 د.ع', Icons.payment, Colors.orange),
              _buildInfoCard('المواد', '6 مواد', Icons.book, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          const Text('آخر التحديثات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildUpdateCard('تم تحديث درجات الفصل اليوم', 'يمكنك مراجعة التفاصيل في قسم الدرجات.'),
          _buildUpdateCard('تم تسجيل الحضور لهذا الأسبوع', 'تشمل الإحصائيات الشهرية والحالية.'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: color),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading: const Icon(Icons.notifications_active, color: Colors.blue),
      ),
    );
  }
}
