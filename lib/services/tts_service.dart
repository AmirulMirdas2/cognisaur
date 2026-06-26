/// File: tts_service.dart
/// Fungsi Utama: Menyediakan fitur Text-To-Speech (TTS) atau pembaca teks menjadi suara.
///
/// Logika & Cara Kerja:
/// 1. Menggunakan library `flutter_tts` bawaan perangkat pengguna.
/// 2. Mengkonfigurasi bahasa ke Bahasa Inggris Amerika ("en-US"), serta mengatur
///    kecepatan bicara (speech rate) dan nada (pitch).
/// 3. Memiliki fungsi `speak()` untuk membacakan teks dan `stop()` untuk menghentikannya.
///
/// Tips Modifikasi:
/// Jika Anda ingin mengganti suara AI menjadi suara khusus (contoh: Google Cloud TTS,
/// ElevenLabs, atau OpenAI TTS API), Anda dapat menaruh kode API pemanggilannya di dalam 
/// fungsi `speak()` ini agar langsung berlaku di seluruh UI.
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