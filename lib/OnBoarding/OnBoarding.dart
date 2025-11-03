import 'package:flutter/material.dart';
import 'package:flutter_application_1/Login/login.dart'; // sesuaikan path-nya

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/illustration1.png",
      "title": "Selamat Datang di Lapor Pak",
      "subtitle": "Solusi digital untuk pengaduan masalah di kampung anda."
    },
    {
      "image": "assets/illustration2.png",
      "title": "Suara Anda, Prioritas Kami",
      "subtitle": "Sampaikan keluhan langsung lewat aplikasi dengan cepat dan tepat."
    },
    {
      "image": "assets/illustration3.png",
      "title": "Jadwal Rapi, Acara Happy!",
      "subtitle": "Lihat jadwal kegiatan RT/RW dalam satu tampilan. Tak ada lagi acara terlewat!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView (isi konten onboarding)
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onboardingData[index]["image"]!,
                        height: screenHeight * 0.35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        onboardingData[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        onboardingData[index]["subtitle"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: _currentIndex == index ? 22 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.deepPurple
                        : Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol navigasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Lewati
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: Text(
                      "Lewati",
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Tombol Berikutnya
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == onboardingData.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7B2FF7),
                            Color(0xFF9F5AFD),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Berikutnya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
