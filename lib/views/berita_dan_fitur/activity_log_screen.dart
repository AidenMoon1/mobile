import 'package:flutter/material.dart';
import '../../models/activity_log_model.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    final List<ActivityLog> logs = [
      ActivityLog(
        date: '20 Juli 2026',
        time: '04:53',
        title: 'Kebencanaan_view_notifikasi',
        description: 'Mengakses layanan kebencanaan_view_notifikasi',
        status: 'Tidak diketahui',
        platform: 'Native Sukabumi one access',
      ),
      ActivityLog(
        date: '19 Juli 2026',
        time: '01.11',
        title: 'csat_click_back',
        description: 'Mengakses layanan csat_click_back',
        status: 'Tidak diketahui',
        platform: 'Native Sukabumi one access',
      ),
      ActivityLog(
        date: '19 Juli 2026',
        time: '00.02',
        title: 'csat_click_back',
        description: 'Mengakses layanan csat_click_back',
        status: 'Tidak diketahui',
        platform: 'Native Sukabumi one access',
      ),
      ActivityLog(
        date: '18 Juli 2026',
        time: '02:45',
        title: 'view_banner_jsa',
        description: 'Mengakses layanan view_banner_jsa',
        status: 'Tidak diketahui',
        platform: 'Native Sukabumi one access',
      ),
      ActivityLog(
        date: '17 Juli 2026',
        time: '12.35',
        title: 'Kebencanaan_view_notifikasi',
        description: 'Mengakses layanan kebencanaan_view_notifikasi',
        status: 'Tidak diketahui',
        platform: 'Native Sukabumi one access',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: accentColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Log ', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'Aktivitas', style: TextStyle(color: accentColor)),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return _buildLogItem(logs[index]);
              },
            ),
          ),
          // Footer section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Batas tampilan tercapai.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Text(
                  'Gunakan "Kirim Data Log ke Email" untuk rentang lengkap.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kirim Data Log ke Email',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(ActivityLog log) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Column
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8A33D),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mail, color: Color(0xFF0A1E33), size: 24),
          ),
          const SizedBox(width: 16),
          // Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.date}, ${log.time}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  log.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  log.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildChip(log.status),
                    const SizedBox(width: 8),
                    _buildChip(log.platform),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }
}
