import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();

  // Konfigurasi awal (bisa dipanggil saat aplikasi pertama kali jalan jika perlu)
  static Future<void> init() async {
    await _flutterTts.setLanguage("en-US"); // Aksen bahasa Inggris Amerika
    await _flutterTts.setSpeechRate(0.4);   // Agak diperlambat agar pelafalannya jelas
    await _flutterTts.setPitch(1.0);        // Nada suara standar
  }

  // Fungsi utama untuk membunyikan teks
  static Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Error (Platform mungkin tidak didukung): $e");
    }
  }

  // Fungsi untuk menghentikan suara (opsional)
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}