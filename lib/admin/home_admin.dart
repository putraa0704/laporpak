import 'package:flutter/material.dart';
import 'package:flutter_application_1/Date/dateadmin.dart';
import 'package:flutter_application_1/history/HistoryAdmin.dart';
import 'package:flutter_application_1/akun/akun_admin.dart';
import 'package:video_player/video_player.dart';
import '../flutterViz_bottom_navigationBar_model.dart';

// ============================================
// 🔹 Widget Video Autoplay di Header
// ============================================
class VideoHeader extends StatefulWidget {
  const VideoHeader({super.key});

  @override
  State<VideoHeader> createState() => _VideoHeaderWargaState();
}

class _VideoHeaderWargaState extends State<VideoHeader> {
  late VideoPlayerController _controller;
  double _volume = 0.5;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/LaporPak.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(_volume);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : _volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth < 400 ? 180 : 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black12,
      ),
      clipBehavior: Clip.antiAlias,
      child: _controller.value.isInitialized
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 0.6,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        color: Colors.black54,
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _toggleMute,
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 5),
                        ),
                        child: SizedBox(
                          width: 80,
                          child: Slider(
                            value: _volume,
                            min: 0,
                            max: 1,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                                if (!_isMuted) {
                                  _controller.setVolume(_volume);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Color(0xff5f34e0)),
            ),
    );
  }
}

// ============================================
// 🔹 Halaman Home Admin (Bottom Nav Diseragamkan)
// ============================================
class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeScreenrtState();
}

class _HomeScreenrtState extends State<HomeAdmin> {
  int _selectedIndex = 0;

  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget? nextPage;
    switch (index) {
      case 0:
        nextPage = const HomeAdmin();
        break;
      case 1:
        nextPage = const DateAdmin();
        break;
      case 2:
        nextPage = const Approvement(); // halaman history admin
        break;
      case 3:
        nextPage = ProfileAdmin();
        break;
    }

    if (nextPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      );
    }
  }

  final List<Map<String, dynamic>> steps = [
    {
      "icon": Icons.report_problem_outlined,
      "title": "1. Buat Laporan",
      "desc": "Warga Melaporkan keluhan dengan jelas dan lengkap.",
    },
    {
      "icon": Icons.upload_file_outlined,
      "title": "2. Unggah Bukti",
      "desc": "Warga Menambahkan foto atau video untuk memperkuat laporan.",
    },
    {
      "icon": Icons.verified_outlined,
      "title": "3. Konfirmasi Oleh Admin",
      "desc": "Laporan Warga akan dikonfirmasi oleh Admin sebelum dikirim ke Ketua RT.",
    },
    {
      "icon": Icons.done_all_outlined,
      "title": "4. Verifikasi Oleh Ketua RT",
      "desc": "Ketua RT akan memverifikasi laporan warga untuk diselesaikan.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      // ✅ Bottom Navigation Bar (sama gaya dengan role warga)
      bottomNavigationBar: BottomNavigationBar(
        items: navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        elevation: 8,
        iconSize: 24,
        selectedItemColor: const Color(0xff5f33e2),
        unselectedItemColor: const Color(0xffb5a1f0),
        selectedFontSize: 10,
        unselectedFontSize: 9,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),

      // ✅ Body tetap sama
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenWidth < 400 ? 250 : 270,
                  decoration: const BoxDecoration(
                    color: Color(0xff5f34e0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.menu, color: Colors.white, size: 26),
                            Text(
                              "Lapor Pak",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.notifications_none,
                                color: Colors.white, size: 26),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const VideoHeader(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: const Color(0xff5f34e0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo, Admin 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Selamat datang di aplikasi Lapor Pak!\nLaporkan keluhan lingkungan dengan mudah dan cepat.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Buat Laporan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Langkah Penggunaan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff5f34e0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double ratio = 1.15;
                      if (constraints.maxWidth < 350) ratio = 0.95;
                      else if (constraints.maxWidth < 400) ratio = 1.05;
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: steps.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: ratio,
                        ),
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff8f6ff),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xffe6e1ff),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff5f34e0).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    step["icon"],
                                    color: const Color(0xff5f34e0),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  step["title"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Flexible(
                                  child: Text(
                                    step["desc"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
