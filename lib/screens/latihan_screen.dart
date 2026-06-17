import 'package:flutter/material.dart';

// --- 1. HALAMAN DETAIL KOSAKATA ---
class VocabularyDetailScreen extends StatelessWidget {
  const VocabularyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.blue),
        title: const Text("CogniSaur", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Icon(Icons.local_fire_department, color: Colors.blue, size: 20),
                SizedBox(width: 4),
                Text("12", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150, width: 150,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("HESITATE", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.volume_up, color: Colors.blue)),
              ],
            ),
            const Text("Ragu-ragu", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16), width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("💡 EXAMPLE SENTENCE", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 8),
                  Text('"I hesitate to ask for help."', style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 4),
                  Text('"Saya ragu-ragu untuk meminta bantuan."', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInfoCard("TYPE", "Verb")),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard("LEVEL", "B2", valueColor: Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16), width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SYNONYMS", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [Chip(label: Text("Pause")), Chip(label: Text("Delay")), Chip(label: Text("Waver"))],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SentencePracticeScreen()));
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

// --- 2. HALAMAN INPUT KALIMAT ---
class SentencePracticeScreen extends StatelessWidget {
  const SentencePracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
        title: const Text("Latihan 1/3", style: TextStyle(color: Colors.black87, fontSize: 16)),
        centerTitle: true, backgroundColor: Colors.white, elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Text("KOSAKATA UTAMA", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const Text("HESITATE", style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Ragu-ragu / bimbang", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.image, size: 40, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('"Jangan ragu untuk mencoba hal baru."', style: TextStyle(fontSize: 12)),
                            Text('"Don\'t hesitate to try new things."', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Kalimat 1", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(hintText: "Tulis kalimat bahasa Inggris pertamamu...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
            const SizedBox(height: 16),
            const Text("Kalimat 2", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(hintText: "Gunakan kata 'hesitate' dalam konteks berbeda...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
            const SizedBox(height: 16),
            const Text("Kalimat 3", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(hintText: "Coba buat kalimat tanya atau negatif...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(child: Text('Tips: Kata kerja ini biasanya diikuti oleh kata "to" + kata kerja bentuk pertama.', style: TextStyle(fontSize: 12, color: Colors.blue))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EvaluationResultScreen()));
                },
                child: const Text("CEK KALIMAT →", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
  const EvaluationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pelajaran 4/10", style: TextStyle(color: Colors.grey, fontSize: 14)),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16.0), child: Center(child: Text("40%", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)))),
        ],
        backgroundColor: Colors.white, elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: 0.4, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Colors.green)),
            const SizedBox(height: 30),
            Container(
              height: 120, width: 120,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Hampir Tepat!", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
                      Icon(Icons.error_outline, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Jangan menyerah, coba lagi!", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12), width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("KALIMAT KAMU", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("I hesitating to speak", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12), width: double.infinity,
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("YANG BENAR", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("I hesitate to speak", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () => Navigator.pop(context),
                child: const Text("PERBAIKI KALIMAT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 50,
              child: TextButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("LEWATI PELAJARAN", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. HALAMAN SUKSES ---
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150, width: 150,
                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, size: 80, color: Colors.green),
              ),
              const SizedBox(height: 30),
              const Text("Luar Biasa!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              const Text("Semua kalimatmu benar. Kamu mendapatkan +15 XP.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatBadge(Icons.local_fire_department, "STREAK", "12 Hari", Colors.green),
                  const SizedBox(width: 16),
                  _buildStatBadge(Icons.monetization_on, "XP", "450", Colors.orange),
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("LANJUT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStatBadge(IconData icon, String label, String value, Color color) {
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
          ),
        ],
      ),
    );
  }
}
