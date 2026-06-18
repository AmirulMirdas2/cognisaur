import 'package:flutter/material.dart';
import '../services/user_prefs.dart';
import 'login_screen.dart'; // Untuk mengarahkan kembali setelah reset
import '../database/db_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tampilkan nama yang saat ini tersimpan di kotak input
    _nameController.text = UserPreferences.getUserName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    if (_nameController.text.trim().isNotEmpty) {
      await UserPreferences.setUserName(_nameController.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengaturan berhasil disimpan!")),
        );
        Navigator.pop(context); // Kembali ke halaman profil
      }
    }
  }

  void _logout() async {
    await UserPreferences.setLoggedIn(false);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _resetApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Aplikasi?"),
        content: const Text("Tindakan ini akan menghapus nama, semua skor XP, streak, dan progres belajar Anda secara permanen. Anda harus login ulang."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL"),
          ),
          TextButton(
            onPressed: () async {
              // 1. Hapus memori lokal
              await UserPreferences.clearAll();
              
              // 2. Hapus isi database
              await DatabaseHelper.instance.clearAllData();
              
              // 3. Arahkan kembali ke LoginScreen dan hapus semua tumpukan halaman terdahulu
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("YA, RESET", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text("AKUN", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          // Ubah Nama
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Nama Pengguna",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 30),
          
          const Text("PROGRES & MEMORI", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          // Tombol Logout
          ListTile(
            onTap: _logout,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.orange[50], shape: BoxShape.circle),
              child: const Icon(Icons.logout, color: Colors.orange),
            ),
            title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            subtitle: const Text("Keluar akun tanpa hapus data", style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),

          // Tombol Reset Data
          ListTile(
            onTap: _resetApp,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
              child: const Icon(Icons.delete_forever, color: Colors.red),
            ),
            title: const Text("Reset Semua Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            subtitle: const Text("Hapus nama, statistik XP, dan siklus SRS", style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 40),
          
          // Tombol Simpan
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: _saveSettings,
              child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}