import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perulangan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Ulangi kosakata untuk ingatan jangka panjang", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF3F51B5), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("STATUS SRS", style: TextStyle(color: Colors.white70, fontSize: 10)),
                const Text("Review Hari Ini", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text("12 Kata Perlu Diulang", style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
                  onPressed: () {},
                  child: const Text("MULAI REVIEW"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Hari Ini", "Penting", Colors.red),
          _buildReviewItem("Hesitate", "Ragu-ragu", "5 Kg"),
          _buildReviewItem("Subtle", "Halus / Samar", "5 Kg"),
          const SizedBox(height: 16),
          _buildSectionHeader("Besok", "23 Kata", Colors.orange),
          _buildReviewItem("Diligent", "Rajin", "Besok"),
          _buildReviewItem("Ambiguous", "Bermakna ganda", "Besok"),
        ],
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
