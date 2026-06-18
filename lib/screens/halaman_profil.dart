import 'package:flutter/material.dart';
import '../services/user_prefs.dart';
import 'settings_screen.dart';
import '../database/db_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tarik data pengguna
    final int xp = UserPreferences.getXP();
    final int level = UserPreferences.getLevel();
    final int streak = UserPreferences.getStreak();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CogniSaur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              // Navigasi ke Halaman Pengaturan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) {
                // Memicu refresh halaman profil jika nama baru saja diubah di halaman Settings
                (context as Element).markNeedsBuild(); 
              });
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
          Center(child: Text(UserPreferences.getUserName(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          // Level dinamis!
          Center(child: Text("Level $level", style: const TextStyle(color: Colors.grey))), 
          const SizedBox(height: 30),
          
          // Stats Grid Dinamis dengan FutureBuilder
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.readAllVocabulary(),
            builder: (context, snapshot) {
              // Menghitung jumlah kata asli dari database
              int totalWords = 0;
              if (snapshot.hasData) {
                totalWords = snapshot.data!.length;
              }

              // Logika akurasi sederhana: Jika belum ada kata, 0%. Jika ada, tampilkan 100% (bisa dikembangkan nanti)
              String akurasi = totalWords == 0 ? "0%" : "100%";

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatBox(Icons.menu_book, "TOTAL KATA", "$totalWords"), // Sekarang dinamis!
                  _buildStatBox(Icons.check_circle_outline, "AKURASI", akurasi), 
                  _buildStatBox(Icons.local_fire_department, "STREAK", "$streak Hari"), 
                  _buildStatBox(Icons.emoji_events, "TOTAL XP", "$xp"), 
                ],
              );
            }
          ),
          const SizedBox(height: 30),
          Builder(
            builder: (context) {
              final int targetHarian = 15;
              final int progressSaatIni = UserPreferences.getDailyProgress();
              
              double progressPersen = (progressSaatIni / targetHarian);
              if (progressPersen > 1.0) progressPersen = 1.0; 
              
              int persentaseBulat = (progressPersen * 100).toInt();

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Target Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("$progressSaatIni/$targetHarian TERKUMPUL", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(value: progressPersen, backgroundColor: Colors.black12, color: Colors.blue),
                        Text("$persentaseBulat%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              );
            }
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

