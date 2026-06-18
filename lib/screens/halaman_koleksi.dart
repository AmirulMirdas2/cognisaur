import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../services/tts_service.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  // Variabel untuk menyimpan state filter
  String _searchQuery = '';
  String _selectedFilter = 'Semua'; // Bisa 'Semua', 'LEMAH', 'SEDANG', 'KUAT'

  // Fungsi pembantu untuk menentukan warna berdasarkan status SRS
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'KUAT':
        return Colors.green;
      case 'SEDANG':
        return Colors.orange;
      case 'LEMAH':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Fungsi untuk memfilter data yang diambil dari SQLite
  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    return data.where((vocab) {
      // 1. Cek Filter Chip
      bool matchesFilter = _selectedFilter == 'Semua' || vocab['status'].toString().toUpperCase() == _selectedFilter;
      
      // 2. Cek Pencarian
      bool matchesSearch = vocab['word'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           vocab['meaning'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CogniSaur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar (Sekarang Berfungsi!)
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari kosakata...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            
            // Filter Chips (Sekarang Berfungsi!)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("Semua"),
                  const SizedBox(width: 8),
                  _buildFilterChip("LEMAH"),
                  const SizedBox(width: 8),
                  _buildFilterChip("SEDANG"),
                  const SizedBox(width: 8),
                  _buildFilterChip("KUAT"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // --- BAGIAN DINAMIS ---
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.instance.readAllVocabulary(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } 
                  else if (snapshot.hasError) {
                    return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                  } 
                  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada kosakata. Silakan tambah kata baru di Beranda."));
                  }

                  // Terapkan filter dan pencarian pada data yang ditarik
                  final filteredList = _filterData(snapshot.data!);

                  if (filteredList.isEmpty) {
                    return const Center(child: Text("Tidak ada kata yang sesuai dengan pencarian/filter."));
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final vocab = filteredList[index];
                      return _buildVocabItem(
                        vocab['word'],
                        vocab['meaning'],
                        vocab['status'],
                        _getStatusColor(vocab['status']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk membuat Filter Chip yang bisa diklik
  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Chip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
        backgroundColor: isSelected ? Colors.blue[600] : Colors.grey[200],
      ),
    );
  }

  // Fungsi pembuat UI per baris kosakata
  Widget _buildVocabItem(String word, String meaning, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  meaning, 
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              
              // Tombol Speaker (Pastikan flutter_tts sudah diinisialisasi)
              GestureDetector(
                onTap: () {
                  TTSService.speak(word); 
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up, size: 20, color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
