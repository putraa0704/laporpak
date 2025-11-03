import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  bool setuju = false;
  bool passwordVisible = false;

  final List<String> roles = ["Ketua RT", "Warga"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xff212435)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              "Masuk",
              style: TextStyle(
                color: Color(0xff6135e1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Daftar Akun",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xff5e31e2),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Silakan isi data di bawah ini untuk membuat akun baru.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
              const SizedBox(height: 30),

              // Nama Lengkap
              _buildInputField(
                controller: namaController,
                label: "Nama Lengkap",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // Role (Peran)
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
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              _buildInputField(
                controller: emailController,
                label: "Email",
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
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xff6135e1),
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Checkbox Persetujuan
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: setuju,
                    onChanged: (value) {
                      setState(() {
                        setuju = value ?? false;
                      });
                    },
                    activeColor: const Color(0xff5e31e2),
                  ),
                  const Expanded(
                    child: Text(
                      "Saya menyetujui syarat dan ketentuan penggunaan aplikasi ini.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Daftar
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
                  onPressed: setuju && selectedRole != null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Akun dengan peran ${selectedRole!} berhasil dibuat!",
                              ),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        }
                      : null,
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
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
