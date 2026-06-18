import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../database/db_helper.dart'; // Sesuaikan path

class DictionaryService {
  // Inisialisasi translator
  static final translator = GoogleTranslator();

  // Daftar kata mentah (Bisa diperpanjang nanti)
  static const List<String> _rawWords = [
    'ubiquitous', 'resilient', 'meticulous', 'eloquent', 'innovative',
    'procrastinate', 'abundant', 'lucid', 'pragmatic', 'ephemeral'
  ];

  // Fungsi untuk mendapatkan Kosakata Baru
  static Future<Map<String, dynamic>?> fetchNewVocabulary() async {
    final db = await DatabaseHelper.instance.database;

    // 1. Cari kata yang belum ada di SQLite
    String? wordToLearn;
    for (String word in _rawWords) {
      // Cek apakah kata ini sudah ada di database
      final result = await db.query('vocabulary', where: 'word = ?', whereArgs: [word]);
      if (result.isEmpty) {
        wordToLearn = word;
        break; // Dapatkan 1 kata dan hentikan pencarian
      }
    }

    // Jika semua kata sudah dipelajari
    if (wordToLearn == null) return null;

    // 2. Panggil Free Dictionary API
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$wordToLearn');
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final entry = data[0];
        
        // Ambil definisi dan contoh pertama yang ditemukan
        String definitionEn = entry['meanings'][0]['definitions'][0]['definition'] ?? 'No definition found.';
        String exampleEn = entry['meanings'][0]['definitions'][0]['example'] ?? 'No example available.';

        // Menerjemahkan menggunakan package secara gratis!
        var translatedDef = await translator.translate(definitionEn, from: 'en', to: 'id');
        var translatedEx = await translator.translate(exampleEn, from: 'en', to: 'id');

        // 3. Masukkan ke database SQLite agar masuk siklus SRS
        Map<String, dynamic> newVocab = {
          'word': wordToLearn,
          'meaning': translatedDef.text, // Teks terjemahan Indonesia
          'example_en': exampleEn,
          'example_id': translatedEx.text, // Teks terjemahan Indonesia
          'status': 'LEMAH',
          'next_review_date': DateTime.now().toIso8601String(), // Langsung review hari ini
          'ease_factor': 2.5,
          'interval_days': 0,
          'repetitions': 0,
        };

        await db.insert('vocabulary', newVocab);
        return newVocab;
        
      } else {
        throw Exception('Gagal mengambil data dari kamus');
      }
    } catch (e) {
      throw Exception('Tidak ada koneksi internet: $e');
    }
  }
}