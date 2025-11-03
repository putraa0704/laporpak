// lib/Signup/signup.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedRole;
  bool setuju = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;

  final List<String> roles = ["rt", "warga"];
  final Map<String, String> roleLabels = {
    "rt": "Ketua RT",
    "warga": "Warga",
  };

  Future<void> _handleRegister() async {
    if (!setuju || selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon setujui persyaratan dan pilih peran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi password tidak sama'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await AuthService.register(
        name: namaController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: selectedRole!,
        address: addressController.text.isNotEmpty ? addressController.text : null,
        phone: phoneController.text.isNotEmpty ? phoneController.text : null,
      );

      setState(() => isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login'),
            backgroundColor: Colors.green,
          ),
        );
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registrasi gagal'),
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
                        child: Text(roleLabels[role]!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedRole = value);
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

              // Phone (Optional)
              _buildInputField(
                controller: phoneController,
                label: "Nomor Telepon (Opsional)",
                icon: Icons.phone,
              ),
              const SizedBox(height: 16),

              // Address (Optional)
              _buildInputField(
                controller: addressController,
                label: "Alamat (Opsional)",
                icon: Icons.location_on,
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

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: !confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Kata Sandi",
                  labelStyle: const TextStyle(color: Color(0xff6135e1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xff6135e1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xff6135e1),
                    ),
                    onPressed: () {
                      setState(() => confirmPasswordVisible = !confirmPasswordVisible);
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
                      setState(() => setuju = value ?? false);
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
                  onPressed: (setuju && selectedRole != null && !isLoading)
                      ? _handleRegister
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