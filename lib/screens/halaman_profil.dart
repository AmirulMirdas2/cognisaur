import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CogniSaur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 40, color: Colors.white))),
          const SizedBox(height: 12),
          const Center(child: Text("Amirul Mirdas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const Center(child: Text("Level 12", style: TextStyle(color: Colors.grey))),
          const SizedBox(height: 30),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.5,
            children: [
              _buildStatBox(Icons.menu_book, "TOTAL KATA", "1,240"),
              _buildStatBox(Icons.check_circle_outline, "AKURASI", "94%"),
              _buildStatBox(Icons.local_fire_department, "STREAK", "12 Hari"),
              _buildStatBox(Icons.emoji_events, "TOTAL XP", "450"),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Target Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("12/15 XP TERKUMPUL", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: const [
                    CircularProgressIndicator(value: 0.8, backgroundColor: Colors.black12, color: Colors.blue),
                    Text("80%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Pengaturan Profile", style: TextStyle(color: Colors.black87, fontSize: 16)),
        backgroundColor: Colors.white, elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Amirul Mirdas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Pelajar Pro • Level 12", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.edit, color: Colors.blue, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("AKUN & PREFERENSI", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_none, color: Colors.blue),
            title: const Text("Notifikasi"), subtitle: const Text("Pemberitahuan latihan harian"),
            trailing: Switch(value: true, activeColor: Colors.blue, onChanged: (val) {}),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.alarm, color: Colors.blue),
            title: const Text("Pengingat Harian"), subtitle: const Text("Setiap hari jam 19:00"),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language, color: Colors.blue),
            title: const Text("Bahasa Aplikasi"), subtitle: const Text("Bahasa Indonesia"),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dark_mode_outlined, color: Colors.blue),
            title: const Text("Mode Gelap"), subtitle: const Text("Tampilan lebih nyaman di mata"),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
        ],
      ),
    );
  }
}
