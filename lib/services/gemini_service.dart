/// File: gemini_service.dart
/// Fungsi Utama: Menangani semua interaksi dan komunikasi antara aplikasi CogniSaur 
///               dengan layanan AI (Google Gemini).
///
/// Logika & Cara Kerja:
/// 1. Mengambil API Key dari file `api_keys.dart`.
/// 2. Membuat instruksi AI (prompt) khusus agar Gemini berperan sebagai guru bahasa Inggris.
/// 3. Mengirimkan 3 kalimat pengguna ke Gemini untuk dievaluasi (case-insensitive).
/// 4. Menerima respons berformat JSON dan mengubahnya (parsing) menjadi format yang bisa 
///    ditampilkan oleh UI Flutter.
///
/// Tips Modifikasi:
/// Jika Anda ingin mengganti AI dari Gemini ke layanan lain (misal Groq Llama 3), Anda 
/// cukup mengubah fungsi `evaluateSentences` ini agar memanggil API endpoint Groq, tanpa
/// harus merusak UI di tempat lain.
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class GeminiService {
  static const String _geminiApiKey = ApiKeys.geminiApiKey;
  static const String _groqApiKey = ApiKeys.groqApiKey;

  /// Mengevaluasi 3 kalimat sekaligus dengan Fallback ke Groq
  static Future<List<Map<String, dynamic>>> evaluateSentences({
    required String targetWord,
    required List<String> userSentences,
  }) async {
    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _geminiApiKey);

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
      // Coba panggil Gemini terlebih dahulu
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '[]';
      return _parseJson(text);
    } catch (geminiError) {
      print("Gemini Error: $geminiError. Beralih ke Groq (Fallback)...");
      
      // Jika Gemini gagal, gunakan Groq API sebagai Fallback
      try {
        final groqUrl = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
        final groqResponse = await http.post(
          groqUrl,
          headers: {
            'Authorization': 'Bearer $_groqApiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "model": "llama-3.1-8b-instant", // Menggunakan model terbaru Groq yang didukung
            "messages": [
              {"role": "system", "content": "You are a helpful assistant that strictly outputs a raw JSON array without markdown formatting or code blocks."},
              {"role": "user", "content": prompt}
            ],
            "temperature": 0.1, // Sangat rendah agar selalu disiplin membalas format JSON
          }),
        );

        if (groqResponse.statusCode == 200) {
          final data = jsonDecode(groqResponse.body);
          final text = data['choices'][0]['message']['content'];
          return _parseJson(text);
        } else {
          throw Exception("Groq API Error: ${groqResponse.statusCode} - ${groqResponse.body}");
        }
      } catch (groqError) {
        // Jika keduanya gagal
        print("Groq Error: $groqError.");
        return List.generate(
          3,
          (index) => {
            "original_sentence": userSentences[index],
            "is_correct": false,
            "corrected_sentence": userSentences[index],
            "feedback_id":
                "Layanan AI sedang sibuk (Gemini & Groq gagal). Coba lagi nanti.",
            "translation_id": "-",
          },
        );
      }
    }
  }

  // Fungsi pembantu (helper) untuk mem-parsing respons JSON
  static List<Map<String, dynamic>> _parseJson(String text) {
    final cleanText = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    List<dynamic> parsedList = jsonDecode(cleanText);
    return parsedList.map((item) => Map<String, dynamic>.from(item)).toList();
  }
}
