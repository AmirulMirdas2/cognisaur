import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../database/db_helper.dart';
import '../services/user_prefs.dart';
import '../services/tts_service.dart';

// --- 1. HALAMAN DETAIL KOSAKATA ---
class VocabularyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> vocabData; // Menerima data dinamis

  const VocabularyDetailScreen({super.key, required this.vocabData});

  @override
  Widget build(BuildContext context) {
    // Mengekstrak data dari Map SQLite
    final String word = vocabData['word'];
    final String meaning = vocabData['meaning'];
    final String exampleEn = vocabData['example_en'];
    final String exampleId = vocabData['example_id'];
    // Jika Anda punya kolom 'type' atau 'level', bisa dipanggil di sini. Sementara kita pakai default.

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan tombol back jika ini tab utama
        title: const Text("CogniSaur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text("12", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.psychology, size: 80, color: Colors.blue), 
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(word.toUpperCase(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5))),
                IconButton(
                  onPressed: () {
                    // Bunyikan kata!
                    TTSService.speak(word);
                  }, 
                  icon: const Icon(Icons.volume_up, color: Colors.blue, size: 32)
                ),
              ],
            ),
            Text(meaning, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            
            // Example Sentence Card Dinamis
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("💡 EXAMPLE SENTENCE", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text('"$exampleEn"', style: const TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                  Text('"$exampleId"', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Type & Level Row (Statis sementara karena tidak ada di DB, bisa disesuaikan nanti)
            Row(
              children: [
                Expanded(child: _buildInfoCard("TYPE", "Verb")),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard("LEVEL", "B2", valueColor: Colors.green)),
              ],
            ),
            const SizedBox(height: 30),
            
            // Button Mulai Latihan Dinamis
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  // Arahkan ke halaman latihan dengan membawa kata yang tepat!
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => SentencePracticeScreen(
                        targetWord: word,
                        meaning: meaning,
                      )
                    )
                  );
                },
                child: const Text("Mulai Latihan ▶", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {Color valueColor = Colors.black87}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: valueColor)),
        ],
      ),
    );
  }
}

class PracticeTabWrapper extends StatelessWidget {
  const PracticeTabWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getTodayReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final reviewList = snapshot.data ?? [];

        // Jika antrean kosong, tampilkan pesan sukses
        if (reviewList.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, size: 100, color: Colors.green),
                  SizedBox(height: 20),
                  Text("Luar Biasa!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Semua jadwal latihan hari ini\nberhasil kamu selesaikan.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        // Jika masih ada, ambil kata urutan PERTAMA dari antrean dan lempar ke halaman Detail
        return VocabularyDetailScreen(vocabData: reviewList.first);
      },
    );
  }
}

// --- 2. HALAMAN INPUT KALIMAT (TOP-LEVEL) ---
class SentencePracticeScreen extends StatefulWidget {
  final String targetWord;
  final String meaning;

  const SentencePracticeScreen({
    super.key, 
    required this.targetWord, 
    required this.meaning
  });

  @override
  State<SentencePracticeScreen> createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen> {
  final TextEditingController _ctrl1 = TextEditingController();
  final TextEditingController _ctrl2 = TextEditingController();
  final TextEditingController _ctrl3 = TextEditingController();

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    super.dispose();
  }

  Future<void> _evaluateSentences() async {
    if (_ctrl1.text.trim().isEmpty ||
        _ctrl2.text.trim().isEmpty ||
        _ctrl3.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap isi ketiga kalimat terlebih dahulu!"),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    List<String> userSentences = [
      _ctrl1.text.trim(),
      _ctrl2.text.trim(),
      _ctrl3.text.trim(),
    ];

    List<Map<String, dynamic>> results;
    try {
      results = await GeminiService.evaluateSentences(
        targetWord: widget.targetWord,
        userSentences: userSentences,
      );
    } catch (e) {
      results = List.generate(
        userSentences.length,
        (index) => {
          "original_sentence": userSentences[index],
          "is_correct": false,
          "corrected_sentence": userSentences[index],
          "feedback_id": "Gagal terhubung ke AI. ($e)",
          "translation_id": "-",
        },
      );
    }

    if (context.mounted) Navigator.pop(context);

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EvaluationResultScreen(
            evaluationResults: results,
            targetWord: widget.targetWord,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Latihan 1/3",
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "KOSAKATA UTAMA",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    widget.targetWord,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.meaning,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Kalimat 1",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl1,
              decoration: InputDecoration(
                hintText: "Tulis kalimat bahasa Inggris pertamamu...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Kalimat 2",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl2,
              decoration: InputDecoration(
                hintText: "Gunakan kata 'hesitate' dalam konteks berbeda...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Kalimat 3",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl3,
              decoration: InputDecoration(
                hintText: "Coba buat kalimat tanya atau negatif...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                ),
                onPressed: _evaluateSentences,
                child: const Text(
                  "CEK KALIMAT →",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. HALAMAN HASIL EVALUASI ---
class EvaluationResultScreen extends StatelessWidget {
  // Variabel untuk menampung hasil yang dikirim dari halaman latihan
  final List<Map<String, dynamic>> evaluationResults;
  final String targetWord;

  const EvaluationResultScreen({
    super.key, 
    required this.evaluationResults,
    required this.targetWord,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung skor
    int correctCount = evaluationResults
        .where((r) => r['is_correct'] == true)
        .length;
    int totalCount = evaluationResults.length;
    bool isAllCorrect = correctCount == totalCount;

    // Warna utama berdasarkan hasil
    Color primaryColor = isAllCorrect
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF6B35);
    Color bgColor = isAllCorrect
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF3E0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header dengan Logo dan Streak ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Tombol kembali
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Logo dan nama
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green.shade100,
                    child: Image.asset(
                      'assets/MascotIntro.png',
                      width: 28,
                      height: 28,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.pets, size: 18, color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "CogniSaur",
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  // Streak
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.blue,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "12",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Progress Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "HASIL EVALUASI",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "$correctCount/$totalCount Benar",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: totalCount > 0 ? correctCount / totalCount : 0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Konten Scrollable ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Mascot Image
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            isAllCorrect
                                ? 'assets/mascotSukes.png'
                                : 'assets/jawabanSalah.png',
                            height: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                isAllCorrect
                                    ? Icons.emoji_emotions
                                    : Icons.sentiment_dissatisfied,
                                size: 80,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isAllCorrect ? Icons.check : Icons.priority_high,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- Status Box ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul Status
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isAllCorrect
                                      ? "Luar Biasa! 🎉"
                                      : "Hampir Tepat!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                isAllCorrect
                                    ? Icons.check_circle
                                    : Icons.error_outline,
                                size: 40,
                                color: primaryColor.withOpacity(0.3),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAllCorrect
                                ? "Semua kalimatmu sudah benar, hebat!"
                                : "Jangan menyerah, coba lagi!",
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- 3 Kartu Jawaban ---
                          ...List.generate(evaluationResults.length, (index) {
                            final result = evaluationResults[index];
                            bool isCorrect = result['is_correct'] ?? false;
                            Color cardBorderColor = isCorrect
                                ? Colors.green.shade300
                                : Colors.red.shade300;
                            Color cardBgColor = isCorrect
                                ? Colors.green.shade50
                                : Colors.white;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: cardBorderColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header: Nomor kalimat & status
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isCorrect
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "KALIMAT ${index + 1}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.red,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Kalimat User
                                  const Text(
                                    "KALIMAT KAMU",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildHighlightedSentence(
                                    result['original_sentence'] ?? '-',
                                    result['corrected_sentence'] ?? '-',
                                    isCorrect,
                                  ),
                                  const SizedBox(height: 10),

                                  // Koreksi (jika salah)
                                  if (!isCorrect) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.green.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "YANG BENAR",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            result['corrected_sentence'] ?? '-',
                                            style: const TextStyle(
                                              color: Color(0xFF2E7D32),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],

                                  // Terjemahan
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "TERJEMAHAN",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          result['translation_id'] ?? '-',
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Feedback AI
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        size: 16,
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          result['feedback_id'] ?? '-',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Tombol Aksi ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                        ),
                        onPressed: () async {
                          if (isAllCorrect) {
                             // 1. Update database SRS
                             await DatabaseHelper.instance.updateSRS(targetWord, true);

                             // 2. Berikan 15 XP dan update Streak harian!
                             await UserPreferences.addXP(15);
                             await UserPreferences.updateStreak();

                             // 3. Update Progress Harian
                             await UserPreferences.incrementDailyProgress();

                             // 4. Pindah ke halaman Sukses
                             if (context.mounted) {
                               Navigator.pushReplacement(
                                 context, 
                                 MaterialPageRoute(builder: (context) => const SuccessScreen()) 
                               );
                             }
                          } else {
                             Navigator.pop(context);
                          }
                        },
                        child: Text(
                          isAllCorrect ? "LANJUTKAN" : "PERBAIKI KALIMAT",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol kedua: Lewati
                    if (!isAllCorrect)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text(
                            "LEWATI PELAJARAN",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menandai kata yang salah di kalimat user
  Widget _buildHighlightedSentence(
    String original,
    String corrected,
    bool isCorrect,
  ) {
    if (isCorrect) {
      return Text(
        original,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }

    // Bandingkan kata per kata (case-insensitive) untuk highlight yang salah
    List<String> originalWords = original.split(' ');
    List<String> correctedWords = corrected.split(' ');

    return RichText(
      text: TextSpan(
        children: List.generate(originalWords.length, (i) {
          bool isWordCorrect =
              i < correctedWords.length &&
              originalWords[i].toLowerCase() == correctedWords[i].toLowerCase();
          return TextSpan(
            text: originalWords[i] + (i < originalWords.length - 1 ? ' ' : ''),
            style: TextStyle(
              color: isWordCorrect ? Colors.black87 : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: isWordCorrect ? null : TextDecoration.underline,
              decorationColor: Colors.red,
            ),
          );
        }),
      ),
    );
  }
}

// --- 4. HALAMAN SUKSES ---
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data asli dari memori perangkat
    final int currentStreak = UserPreferences.getStreak();
    final int currentXP = UserPreferences.getXP();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
              ),
              const SizedBox(height: 30),
              const Text("Luar Biasa!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              const Text("Semua kalimatmu benar. Kamu mendapatkan +15 XP.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              
              // Menampilkan data dinamis di sini!
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatBadge(Icons.local_fire_department, "STREAK", "$currentStreak Hari", Colors.green),
                  const SizedBox(width: 16),
                  _buildStatBadge(Icons.monetization_on, "XP TOTAL", "$currentXP", Colors.orange),
                ],
              ),
              const SizedBox(height: 50),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("LANJUT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          )
        ],
      ),
    );
  }
}
