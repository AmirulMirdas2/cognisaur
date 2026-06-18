import 'package:flutter/material.dart';
import '../database/db_helper.dart'; // Sesuaikan path

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  
  // Fungsi untuk mengambil dan mengelompokkan data
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAndGroupReviews() async {
    final allVocab = await DatabaseHelper.instance.readAllVocabulary();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    List<Map<String, dynamic>> todayList = [];
    List<Map<String, dynamic>> tomorrowList = [];
    List<Map<String, dynamic>> upcomingList = [];

    for (var vocab in allVocab) {
      DateTime reviewDate = DateTime.parse(vocab['next_review_date']);
      DateTime normalizedReviewDate = DateTime(reviewDate.year, reviewDate.month, reviewDate.day);

      if (normalizedReviewDate.isBefore(tomorrow)) {
        todayList.add(vocab);
      } else if (normalizedReviewDate.isAtSameMomentAs(tomorrow)) {
        tomorrowList.add(vocab);
      } else {
        upcomingList.add(vocab);
      }
    }

    return {
      'today': todayList,
      'tomorrow': tomorrowList,
      'upcoming': upcomingList,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perulangan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _fetchAndGroupReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final groupedData = snapshot.data!;
          final todayList = groupedData['today']!;
          final tomorrowList = groupedData['tomorrow']!;
          final upcomingList = groupedData['upcoming']!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text("Ulangi kosakata untuk ingatan jangka panjang", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              
              // SRS Banner Dinamis
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF3F51B5), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("STATUS SRS", style: TextStyle(color: Colors.white70, fontSize: 10)),
                    const Text("Review Hari Ini", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("${todayList.length} Kata Perlu Diulang", style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Section: Hari Ini
              if (todayList.isNotEmpty) ...[
                _buildSectionHeader("Hari Ini", "Penting", Colors.red),
                ...todayList.map((vocab) => _buildReviewItem(vocab['word'], vocab['meaning'], "Hari Ini")),
                const SizedBox(height: 16),
              ],
              
              // Section: Besok
              if (tomorrowList.isNotEmpty) ...[
                _buildSectionHeader("Besok", "${tomorrowList.length} Kata", Colors.orange),
                ...tomorrowList.map((vocab) => _buildReviewItem(vocab['word'], vocab['meaning'], "Besok")),
                const SizedBox(height: 16),
              ],

              // Section: Mendatang
              if (upcomingList.isNotEmpty) ...[
                _buildSectionHeader("Mendatang", "${upcomingList.length} Kata", Colors.green),
                ...upcomingList.map((vocab) => _buildReviewItem(vocab['word'], vocab['meaning'], "${vocab['interval_days']} Hari")),
              ],

              // Jika semua kosong
              if (todayList.isEmpty && tomorrowList.isEmpty && upcomingList.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text("Belum ada kosakata di jadwalmu.", style: TextStyle(color: Colors.grey))),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badgeText, Color badgeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: badgeColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String word, String meaning, String info) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(word, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(meaning, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(info, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
