import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../database/db_helper.dart'; // Sesuaikan path
import 'user_prefs.dart';

class DictionaryService {
  // Inisialisasi translator
  static final translator = GoogleTranslator();

  // 1. KELOMPOKKAN KATA MENTAH BERDASARKAN JENISNYA
  static const Map<String, List<String>> _categorizedWords = {
    'Noun': ['resilience', 'philosophy', 'metaphor', 'innovation', 'obstacle'],
    'Verb': ['persist', 'hesitate', 'evaluate', 'procrastinate', 'mitigate'],
    'Adjective': ['ubiquitous', 'meticulous', 'subtle', 'eloquent', 'pragmatic'],
  };

  // Fungsi pembantu untuk mendapatkan tipe kata
  static String getWordType(String word) {
    for (var entry in _categorizedWords.entries) {
      if (entry.value.contains(word.toLowerCase())) {
        return entry.key;
      }
    }
    return "Vocabulary";
  }

  // Fungsi untuk mendapatkan Kosakata Baru
  static Future<Map<String, dynamic>?> fetchNewVocabulary() async {
    final db = await DatabaseHelper.instance.database;

    // 2. AMBIL FOKUS BELAJAR PENGGUNA SAAT INI
    String focus = UserPreferences.getWordTypeFocus();
    
    List<String> poolOfWords = [];

    // 3. TENTUKAN SUMBER KATA BERDASARKAN FOKUS
    if (focus == 'Semua') {
      // Gabungkan semua kata dari semua kategori
      _categorizedWords.values.forEach((list) => poolOfWords.addAll(list));
    } else {
      // Ambil kata hanya dari kategori yang dipilih (misal 'Noun' atau 'Verb')
      poolOfWords = List.from(_categorizedWords[focus] ?? []);
    }

    // Acak urutan agar lebih natural (Opsional)
    poolOfWords.shuffle();

    String? wordToLearn;
    for (String word in poolOfWords) {
      final result = await db.query('vocabulary', where: 'word = ?', whereArgs: [word]);
      if (result.isEmpty) {
        wordToLearn = word;
        break; 
      }
    }

    if (wordToLearn == null) return null; // Jika habis

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