import 'package:flutter/material.dart';
import 'latihan_screen.dart';

void main() {
  runApp(const CogniSaurApp());
}

class CogniSaurApp extends StatelessWidget {
  const CogniSaurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniSaur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'sans-serif'),
      home: const Opening1(),
    );
  }
}

// --- HALAMAN 1: OPENING 1 ---
class Opening1 extends StatelessWidget {
  const Opening1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF546FFF), // Biru gelap
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/MascotIntro.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "CogniSaur",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "LEVEL UP YOUR MIND",
              style: TextStyle(color: Colors.white70, letterSpacing: 2),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Opening2()),
              ),
              child: const Text("Mulai Belajar"),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN 2: OPENING 2 (Belajar Kosakata) ---
class Opening2 extends StatelessWidget {
  const Opening2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Intro2.png', height: 200, fit: BoxFit.contain),
            const SizedBox(height: 30),
            const Text(
              "Belajar Kosakata Baru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "Pelajari kata-kata bahasa Inggris pilihan setiap hari dengan cara yang menyenangkan.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(radius: 5, backgroundColor: Colors.blue),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Opening3()),
                ),
                child: const Text("LANJUT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN 3: OPENING 3 (Tulis Kalimat) ---
class Opening3 extends StatelessWidget {
  const Opening3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Intro3.png', height: 200, fit: BoxFit.contain),
            const SizedBox(height: 30),
            const Text(
              "Tulis Kalimatmu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "Tingkatkan ingatanmu dengan membuat 3 kalimat untuk setiap kosakata baru.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.blue),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Opening4()),
                ),
                child: const Text("LANJUT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN 4: OPENING 4 (Review Berkala) ---
class Opening4 extends StatelessWidget {
  const Opening4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Intro4.png', height: 200, fit: BoxFit.contain),
            const SizedBox(height: 30),
            const Text(
              "Review Berkala",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "Metode Spaced Repetition membantu kamu mengingat selamanya.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                SizedBox(width: 5),
                CircleAvatar(radius: 5, backgroundColor: Colors.blue),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                ),
                child: const Text("MULAI"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN 5: MULAI BELAJAR (Main Menu) ---
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CogniSaur")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Intro5.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const Text(
              "Mulai Petualangan Belajarmu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Belajar tanpa tapi, ayo semangat. Langsung masuk ke materi favoritmu.",
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                child: const Text(
                  "MULAI BELAJAR ->",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
