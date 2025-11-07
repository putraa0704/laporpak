import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import '../Date/date.dart';
import '../Formulir/tambah.dart';
import '../history/history.dart';
import '../akun/akun.dart';

// ============================================
// 🔹 Widget Video Autoplay di Header
// ============================================
class VideoHeaderWarga extends StatefulWidget {
  const VideoHeaderWarga({super.key});

  @override
  State<VideoHeaderWarga> createState() => _VideoHeaderWargaState();
}

class _VideoHeaderWargaState extends State<VideoHeaderWarga> {
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
// 🔹 Halaman Home untuk Warga
// ============================================
class HomeWarga extends StatefulWidget {
  const HomeWarga({super.key});

  @override
  State<HomeWarga> createState() => _HomeWargaState();
}

class _HomeWargaState extends State<HomeWarga> {
  int _selectedIndex = 0;

  final List<FlutterVizBottomNavigationBarModel> flutterVizBottomNavigationBarItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.add, label: "Tambah"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  final List<Map<String, dynamic>> steps = [
    {
      "icon": Icons.report_problem_outlined,
      "title": "1. Buat Laporan",
      "desc": "Laporkan keluhan warga dengan jelas dan lengkap.",
    },
    {
      "icon": Icons.upload_file_outlined,
      "title": "2. Unggah Bukti",
      "desc": "Tambahkan foto atau video untuk memperkuat laporan Anda.",
    },
    {
      "icon": Icons.verified_outlined,
      "title": "3. Diverifikasi RT",
      "desc": "Laporan Anda akan diverifikasi oleh ketua RT.",
    },
    {
      "icon": Icons.done_all_outlined,
      "title": "4. Selesai",
      "desc": "Pantau hingga laporan Anda ditangani dengan baik.",
    },
  ];

  // ✅ fungsi navigasi bawah (disamakan seperti DatePage)
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWarga()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DatePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UploadKeluhan()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryLaporan()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Menu ${flutterVizBottomNavigationBarItems[index].label} belum diaktifkan")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      // ✅ Bottom Navigation disamakan dengan DatePage
      bottomNavigationBar: BottomNavigationBar(
        items: flutterVizBottomNavigationBarItems
            .map((e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.label))
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
                      const VideoHeaderWarga(),
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
                    "Halo, Warga 👋",
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadKeluhan()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                  const Row(
                    children: [
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
    childAspectRatio: screenWidth < 350 ? 0.85 : screenWidth < 400 ? 0.95 : 1.0,
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
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff5f34e0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              step["icon"],
              color: const Color(0xff5f34e0),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step["title"],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              step["desc"],
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  },
);                    },
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
