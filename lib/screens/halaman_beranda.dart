import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../services/user_prefs.dart';
import '../services/dictionary_service.dart';
import 'latihan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fungsi untuk mengambil data review hari ini
  Future<List<Map<String, dynamic>>> _fetchTodayReviews() async {
    return await DatabaseHelper.instance.getTodayReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hai, ${UserPreferences.getUserName()}!", style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Siap belajar hari ini?", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                const SizedBox(width: 4),
                Text("${UserPreferences.getStreak()}", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTodayReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Mendapatkan daftar kata yang perlu direview
          final reviewList = snapshot.data ?? [];
          final reviewCount = reviewList.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Target Harian Widget (Sekarang Dinamis!)
                Builder( // Kita gunakan Builder agar bisa mengambil variabel lokal dengan rapi
                  builder: (context) {
                    final int targetHarian = 15; // Target misalnya 15 kata per hari
                    final int progressSaatIni = UserPreferences.getDailyProgress();
                    
                    // Mencegah nilai melebihi 1.0 (100%)
                    double progressPersen = (progressSaatIni / targetHarian);
                    if (progressPersen > 1.0) progressPersen = 1.0; 
                    
                    int persentaseBulat = (progressPersen * 100).toInt();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("TARGET HARIAN", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("$progressSaatIni / $targetHarian Kosakata", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("$persentaseBulat%", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progressPersen, // Nilai yang menggerakkan garis biru (0.0 sampai 1.0)
                                backgroundColor: Colors.grey[200], 
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), 
                                minHeight: 8, 
                                borderRadius: BorderRadius.circular(4)
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
                const SizedBox(height: 30),

                // Aksi Utama: Review SRS Dinamis
                const Text("TUGAS HARI INI", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                
                // Kondisi: Jika ada kata yang harus direview
                if (reviewCount > 0)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF3F51B5), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                                child: const Text("URGENT", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 12),
                              const Text("Review SRS", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              // Jumlah kata dinamis dari database
                              Text("Ada $reviewCount kata yang mulai kamu lupakan. Segarkan ingatanmu sekarang!", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF3F51B5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                onPressed: () {
                                  // Navigasi ke halaman latihan menggunakan kata pertama dari antrean
                                  final firstWord = reviewList[0];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SentencePracticeScreen(
                                        targetWord: firstWord['word'],
                                        meaning: firstWord['meaning'],
                                      ),
                                    ),
                                  ).then((_) {
                                    // Me-refresh halaman beranda setelah kembali dari latihan
                                    setState(() {});
                                  });
                                },
                                child: const Text("MULAI REVIEW"),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.psychology, size: 80, color: Colors.white54),
                      ],
                    ),
                  )
                // Kondisi: Jika review hari ini sudah habis/kosong
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Selesai!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text("Kamu sudah menyelesaikan semua jadwal review SRS hari ini. Ingatanmu aman!", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.check_circle, size: 80, color: Colors.white54),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Aksi Sekunder: Kosakata Baru
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blue.shade100)),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_stories, size: 60, color: Colors.blue),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Kosakata Baru", style: TextStyle(color: Color(0xFF3F51B5), fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text("Pelajari kata baru hari ini untuk memperluas bank katamu.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF3F51B5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              onPressed: () async {
                                // Tampilkan loading dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator()),
                                );

                                try {
                                  // Tarik kosakata baru dari API & Simpan ke DB
                                  final newVocab = await DictionaryService.fetchNewVocabulary();
                                  
                                  // Tutup loading
                                  if (context.mounted) Navigator.pop(context);

                                  if (newVocab != null && context.mounted) {
                                    // Arahkan langsung ke halaman latihan untuk kata baru ini!
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SentencePracticeScreen(
                                          targetWord: newVocab['word'],
                                          meaning: newVocab['meaning'],
                                        ),
                                      ),
                                    ).then((_) {
                                      // Refresh beranda saat kembali
                                      setState(() {});
                                    });
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kamu sudah mempelajari semua kata yang tersedia!")));
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context); // Tutup loading
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                }
                              },
                              child: const Text("PELAJARI", style: TextStyle(color: Color(0xFF3F51B5))),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}