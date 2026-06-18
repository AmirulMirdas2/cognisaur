import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/api_keys.dart';

class GeminiService {
  static const String _apiKey = ApiKeys.geminiApiKey;

  /// Mengevaluasi 3 kalimat sekaligus
  static Future<List<Map<String, dynamic>>> evaluateSentences({
    required String targetWord,
    required List<String> userSentences,
  }) async {
    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

    // Prompt diperbarui untuk menangani array kalimat
    final prompt =
        '''
      Kamu adalah guru bahasa Inggris yang tegas namun mendukung.
      Tugasmu adalah mengevaluasi 3 kalimat yang dibuat oleh murid. 
      Setiap kalimat harus menggunakan kata target: "$targetWord".
      
      PENTING: Abaikan perbedaan huruf besar/kecil (case-insensitive) saat mengevaluasi.
      Contoh: "i hesitate" dan "I hesitate" dianggap SAMA BENAR.
      Jangan anggap salah hanya karena perbedaan kapitalisasi.
      Fokuskan evaluasi pada grammar, struktur kalimat, dan penggunaan kata target yang benar.
      
      Berikut adalah 3 kalimat buatan murid:
      1. "${userSentences[0]}"
      2. "${userSentences[1]}"
      3. "${userSentences[2]}"
      
      Periksa apakah grammar-nya benar, struktur kalimatnya logis, dan apakah kata "$targetWord" digunakan dengan benar sesuai konteks.
      Sekali lagi, JANGAN tandai salah hanya karena huruf besar/kecil berbeda.
      
      Balas HANYA dengan format JSON berwujud ARRAY murni persis seperti struktur di bawah ini tanpa tambahan markdown (jangan gunakan ```json):
      [
        {
          "original_sentence": "${userSentences[0]}",
          "is_correct": true/false,
          "corrected_sentence": "Tulis kalimat yang benar di sini. Jika sudah benar, tulis ulang aslinya.",
          "feedback_id": "Penjelasan singkat dalam bahasa Indonesia maksimal 2 kalimat mengenai letak kesalahan, atau pujian jika benar.",
          "translation_id": "Terjemahan kalimat yang benar ke dalam bahasa Indonesia."
        },
        // ... (Lanjutkan untuk kalimat ke-2 dan ke-3 dengan struktur yang sama)
      ]
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '[]';

      final cleanText = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Karena kita meminta array JSON, kita perlu melakukan casting (konversi) ke List
      List<dynamic> parsedList = jsonDecode(cleanText);

      // Mengubah setiap elemen dinamis menjadi Map berformat string
      return parsedList.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      // Jika terjadi error (misal internet mati), kembalikan array berisi pesan error
      return List.generate(
        3,
        (index) => {
          "original_sentence": userSentences[index],
          "is_correct": false,
          "corrected_sentence": userSentences[index],
          "feedback_id":
              "Gagal terhubung ke AI. Cek koneksi internet Anda. ($e)",
          "translation_id": "-",
        },
      );
    }
  }
}
