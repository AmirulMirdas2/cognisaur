import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Membuka atau membuat koneksi database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cognisaur.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Tingkatkan versi jika Anda mengubah struktur tabel di masa depan
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel dan menyuntikkan data awal (Seed Data)
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // 1. Membuat Tabel Vocabulary (beserta parameter SRS SM-2)
    await db.execute('''
      CREATE TABLE vocabulary (
        id $idType,
        word $textType,
        meaning $textType,
        example_en $textType,
        example_id $textType,
        status $textType, 
        next_review_date $textType, 
        ease_factor $realType,
        interval_days $intType,
        repetitions $intType
      )
    ''');

    // 2. Membuat Tabel Statistik Harian
    await db.execute('''
      CREATE TABLE daily_statistics (
        id $idType,
        date $textType,
        words_reviewed $intType
      )
    ''');

    // 3. Menyuntikkan Seed Data (Kosakata Terkurasi)
    // await _insertSeedData(db);
  }

  // Future _insertSeedData(Database db) async {
  //   final today = DateTime.now().toIso8601String(); // Default review hari ini

  //   List<Map<String, dynamic>> initialVocabs = [
  //     {
  //       'word': 'Hesitate',
  //       'meaning': 'Ragu-ragu / Bimbang',
  //       'example_en': "Don't hesitate to try new things.",
  //       'example_id': "Jangan ragu untuk mencoba hal baru.",
  //       'status': 'LEMAH',
  //       'next_review_date': today,
  //       'ease_factor': 2.5,
  //       'interval_days': 0,
  //       'repetitions': 0,
  //     },
  //     {
  //       'word': 'Diligent',
  //       'meaning': 'Rajin',
  //       'example_en': "She is a diligent student.",
  //       'example_id': "Dia adalah murid yang rajin.",
  //       'status': 'SEDANG',
  //       'next_review_date': today,
  //       'ease_factor': 2.5,
  //       'interval_days': 0,
  //       'repetitions': 0,
  //     },
  //     {
  //       'word': 'Persist',
  //       'meaning': 'Bertahan / Gigih',
  //       'example_en': "If you persist, you will succeed.",
  //       'example_id': "Jika kamu gigih, kamu akan berhasil.",
  //       'status': 'KUAT',
  //       'next_review_date': today,
  //       'ease_factor': 2.5,
  //       'interval_days': 0,
  //       'repetitions': 0,
  //     },
  //     {
  //       'word': 'Ambiguous',
  //       'meaning': 'Bermakna ganda / Tidak jelas',
  //       'example_en': "His answer was very ambiguous.",
  //       'example_id': "Jawabannya sangat ambigu.",
  //       'status': 'LEMAH',
  //       'next_review_date': today,
  //       'ease_factor': 2.5,
  //       'interval_days': 0,
  //       'repetitions': 0,
  //     },
  //     {
  //       'word': 'Subtle',
  //       'meaning': 'Halus / Samar',
  //       'example_en': "There is a subtle difference between the two.",
  //       'example_id': "Ada perbedaan yang samar di antara keduanya.",
  //       'status': 'SEDANG',
  //       'next_review_date': today,
  //       'ease_factor': 2.5,
  //       'interval_days': 0,
  //       'repetitions': 0,
  //     },
  //   ];

  //   for (var vocab in initialVocabs) {
  //     await db.insert('vocabulary', vocab);
  //   }
  // }

  // Fungsi utilitas untuk membaca semua kosakata
  Future<List<Map<String, dynamic>>> readAllVocabulary() async {
    final db = await instance.database;
    return await db.query('vocabulary', orderBy: 'word ASC');
  }

  // Fungsi utilitas untuk mengambil kosakata yang jadwal review-nya hari ini atau lewat
  Future<List<Map<String, dynamic>>> getTodayReviews() async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String();

    return await db.query(
      'vocabulary',
      where: 'next_review_date <= ?',
      whereArgs: [today],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> updateSRS(String word, bool isCorrect) async {
    final db = await instance.database;

    // Ambil data kata saat ini
    final List<Map<String, dynamic>> maps = await db.query(
      'vocabulary',
      where: 'word = ?',
      whereArgs: [word],
    );

    if (maps.isNotEmpty) {
      final vocab = maps.first;
      int repetitions = vocab['repetitions'] as int;
      double easeFactor = vocab['ease_factor'] as double;
      int intervalDays = vocab['interval_days'] as int;

      if (isCorrect) {
        // Jika jawaban benar, naikkan repetisi dan hitung interval baru
        repetitions += 1;

        if (repetitions == 1) {
          intervalDays = 1; // Ulangi besok
        } else if (repetitions == 2) {
          intervalDays = 6; // Ulangi 6 hari lagi
        } else {
          intervalDays = (intervalDays * easeFactor)
              .round(); // Kalikan dengan Ease Factor
        }

        // Sedikit menaikkan ease factor karena berhasil dijawab
        easeFactor += 0.1;
      } else {
        // Jika salah/sulit, reset repetisi ke 0 dan turunkan ease factor
        repetitions = 0;
        intervalDays = 1; // Harus diulang besok
        easeFactor = (easeFactor - 0.2 < 1.3)
            ? 1.3
            : easeFactor - 0.2; // Batas minimum EF adalah 1.3
      }

      // Hitung tanggal review berikutnya
      DateTime nextReviewDate = DateTime.now().add(
        Duration(days: intervalDays),
      );

      // Tentukan status untuk UI (Lemah, Sedang, Kuat)
      String status = 'LEMAH';
      if (intervalDays > 7) {
        status = 'KUAT';
      } else if (intervalDays > 2) {
        status = 'SEDANG';
      }

      // Update data di SQLite
      await db.update(
        'vocabulary',
        {
          'repetitions': repetitions,
          'ease_factor': easeFactor,
          'interval_days': intervalDays,
          'next_review_date': nextReviewDate.toIso8601String(),
          'status': status,
        },
        where: 'word = ?',
        whereArgs: [word],
      );
    }
  }

  // Fungsi untuk mereset seluruh data di database (menghapus semua tabel)
  Future<void> clearAllData() async {
    final db = await instance.database;
    await db.delete('vocabulary');
    await db.delete('daily_statistics');
  }
}
