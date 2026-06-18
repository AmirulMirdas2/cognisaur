import 'package:flutter/material.dart';
import '../services/user_prefs.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginMode = true; // true = Login, false = Register
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Hanya untuk register

  void _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || (!isLoginMode && email.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua kolom!")),
      );
      return;
    }

    if (isLoginMode) {
      // PROSES LOGIN
      final savedUsername = UserPreferences.getRegUsername();
      final savedPassword = UserPreferences.getRegPassword();
      
      if (savedUsername == username && savedPassword == password) {
        // Berhasil login
        await UserPreferences.setUserName(username);
        await UserPreferences.setNotFirstTime();
        await UserPreferences.setLoggedIn(true);
        if (context.mounted) _goToHome();
      } else {
        // Gagal login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username atau password salah, atau belum terdaftar!")),
        );
      }
    } else {
      // PROSES REGISTER
      await UserPreferences.registerUser(username, email, password);
      // Langsung login setelah register
      await UserPreferences.setUserName(username);
      await UserPreferences.setNotFirstTime();
      await UserPreferences.setLoggedIn(true);
      if (context.mounted) _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()), 
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/MascotIntro.png', height: 120, fit: BoxFit.contain),
                const SizedBox(height: 24),
                Text(
                  isLoginMode ? "Selamat Datang Kembali!" : "Buat Akun Baru",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF3F51B5)
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isLoginMode 
                    ? "Masuk untuk melanjutkan belajarmu" 
                    : "Daftar untuk mulai melatih ingatanmu",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                
                // Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Email (hanya saat register)
                if (!isLoginMode) ...[
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 30),
                
                // Tombol Submit
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isLoginMode ? "MASUK" : "DAFTAR SEKARANG", 
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Toggle
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = !isLoginMode;
                      // Bersihkan input saat berganti mode
                      _usernameController.clear();
                      _passwordController.clear();
                      _emailController.clear();
                    });
                  },
                  child: Text(
                    isLoginMode 
                      ? "Belum punya akun? Daftar di sini" 
                      : "Sudah punya akun? Masuk di sini",
                    style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}