import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  // Inisialisasi awal
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- XP & LEVEL ---
  static int getXP() => _prefs.getInt('user_xp') ?? 0;
  
  static Future<void> addXP(int amount) async {
    int currentXP = getXP();
    await _prefs.setInt('user_xp', currentXP + amount);
  }

  static int getLevel() {
    // Logika sederhana: 1 Level = 100 XP
    return (getXP() / 100).floor() + 1;
  }

  // --- STREAK ---
  static int getStreak() => _prefs.getInt('user_streak') ?? 0;

  static Future<void> updateStreak() async {
    String today = DateTime.now().toIso8601String().split('T')[0];
    String lastStudyDate = _prefs.getString('last_study_date') ?? '';

    if (lastStudyDate != today) {
      // Jika terakhir belajar adalah kemarin, tambah streak
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
      String yesterdayStr = yesterday.toIso8601String().split('T')[0];

      if (lastStudyDate == yesterdayStr) {
        await _prefs.setInt('user_streak', getStreak() + 1);
      } else if (lastStudyDate.isNotEmpty) {
        // Jika bolong (tidak belajar kemarin), reset streak
        await _prefs.setInt('user_streak', 1);
      } else {
        // Belajar untuk pertama kalinya
        await _prefs.setInt('user_streak', 1);
      }
      
      // Catat hari ini sebagai hari terakhir belajar
      await _prefs.setString('last_study_date', today);
    }
  }

  // --- TARGET HARIAN ---
  static int getDailyProgress() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    String progressDate = _prefs.getString('progress_date') ?? '';
    
    // Jika tanggal terakhir menyimpan progress bukan hari ini, berarti reset ke 0
    if (progressDate != today) {
      return 0; 
    }
    return _prefs.getInt('daily_progress') ?? 0;
  }

  static Future<void> incrementDailyProgress() async {
    String today = DateTime.now().toIso8601String().split('T')[0];
    String progressDate = _prefs.getString('progress_date') ?? '';

    if (progressDate != today) {
      // Hari baru: set tanggal hari ini dan mulai progress dari 1
      await _prefs.setString('progress_date', today);
      await _prefs.setInt('daily_progress', 1);
    } else {
      // Hari yang sama: tambahkan progress sebelumnya dengan 1
      int current = _prefs.getInt('daily_progress') ?? 0;
      await _prefs.setInt('daily_progress', current + 1);
    }
  }

  // --- NAMA PENGGUNA & STATUS BARU ---
  static Future<void> setUserName(String name) async {
    await _prefs.setString('user_name', name);
  }

  static String getUserName() {
    return _prefs.getString('user_name') ?? 'Amirul';
  }

  static Future<void> setNotFirstTime() async {
    await _prefs.setBool('is_first_time', false);
  }

  static bool isFirstTime() {
    return _prefs.getBool('is_first_time') ?? true;
  }

  // --- CREDENTIALS (MOCK) ---
  static Future<void> registerUser(String username, String email, String password) async {
    await _prefs.setString('reg_username', username);
    await _prefs.setString('reg_email', email);
    await _prefs.setString('reg_password', password);
  }

  static String getRegUsername() => _prefs.getString('reg_username') ?? '';
  static String getRegPassword() => _prefs.getString('reg_password') ?? '';

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('is_logged_in', value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  // --- RESET DATA ---
  static Future<void> clearAll() async {
    await _prefs.clear(); // Menghapus seluruh data di SharedPreferences
  }
}