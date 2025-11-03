// lib/Login/login.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  bool setuju = false;
  bool passwordVisible = false;
  bool isLoading = false;

  final List<String> roles = ["rt", "warga", "admin"];
  final Map<String, String> roleLabels = {
    "rt": "Ketua RT",
    "warga": "Warga",
    "admin": "Admin",
  };

  Future<void> _handleLogin() async {
    if (!setuju || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon setujui persyaratan dan pilih peran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() => isLoading = false);

      if (result['success']) {
        final userData = result['data']['user'];
        final user = UserModel.fromJson(userData);

        // Cek role sesuai dengan pilihan
        if (user.role != selectedRole) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role tidak sesuai! Anda login sebagai ${roleLabels[user.role]}'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat datang, ${user.name}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi sesuai role
        if (!mounted) return;
        switch (user.role) {
          case 'rt':
            Navigator.pushReplacementNamed(context, '/rt_home');
            break;
          case 'warga':
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 'admin':
            Navigator.pushReplacementNamed(context, '/home_admin');
            break;
          default:
            Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff212435)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Masuk Akun",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xff5e31e2),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Silakan isi data di bawah ini untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
              const SizedBox(height: 30),

              // Email
              _buildInputField(
                controller: emailController,
                label: "Alamat Email",
                icon: Icons.mail,
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  labelStyle: const TextStyle(color: Color(0xff6135e1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xff6135e1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xff6135e1),
                    ),
                    onPressed: () {
                      setState(() => passwordVisible = !passwordVisible);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown Role
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff6135e1), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    hint: const Text("Pilih Peran"),
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(roleLabels[role]!),
                            const Text(
                              "Pilih",
                              style: TextStyle(color: Color(0xff6135e1)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedRole = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: setuju,
                    onChanged: (value) {
                      setState(() => setuju = value ?? false);
                    },
                    activeColor: const Color(0xff5e31e2),
                  ),
                  const Expanded(
                    child: Text(
                      "Saya telah membaca dan menyetujui Kebijakan Privasi serta Syarat dan Ketentuan.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: setuju && selectedRole != null
                        ? const Color(0xff6236e6)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (setuju && selectedRole != null && !isLoading)
                      ? _handleLogin
                      : null,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text(
                      "Daftar di sini",
                      style: TextStyle(
                        color: Color(0xff5e31e2),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Dengan melanjutkan, Anda menyetujui ketentuan yang berlaku.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xff807d7d)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xff6135e1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: const Color(0xff6135e1)),
      ),
    );
  }
}