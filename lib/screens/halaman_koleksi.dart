import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CogniSaur",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Cari kosakata...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Chip(
                  label: const Text("Semua", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue[600],
                ),
                const SizedBox(width: 8),
                const Chip(label: Text("Lemah")),
                const SizedBox(width: 8),
                const Chip(label: Text("Sedang")),
                const SizedBox(width: 8),
                const Chip(label: Text("Kuat")),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Siap Review?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      SizedBox(height: 4),
                      Text("Kamu punya 12 kata lemah yang perlu diperkuat hari ini.", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                const Icon(Icons.psychology, size: 40, color: Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildVocabItem("Hesitate", "Ragu-ragu", "LEMAH", Colors.red),
          _buildVocabItem("Diligent", "Rajin", "SEDANG", Colors.orange),
          _buildVocabItem("Persist", "Bertahan / Gigih", "KUAT", Colors.green),
          _buildVocabItem("Ambiguous", "Ambigu / Tidak Jelas", "SEDANG", Colors.orange),
          _buildVocabItem("Subtle", "Halus / Samar", "LEMAH", Colors.red),
        ],
      ),
    );
  }

  Widget _buildVocabItem(String word, String meaning, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(word, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(meaning, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.volume_up, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
