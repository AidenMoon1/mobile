import 'package:flutter/material.dart';
import 'info_disdukcapil.dart';
import 'info_diskominfo.dart';
import 'info_dpmpstp.dart';
import 'info_dkp3.dart';
import 'info_bpkpd.dart';

class InstansiScreen extends StatelessWidget {
  const InstansiScreen({super.key});

  final List<Map<String, dynamic>> _instansiList = const [
    {
      'title': 'Disdukcapil',
      'image': 'assets/images/disduk.png',
      'icon': Icons.badge_rounded,
      'desc': 'Dinas Kependudukan dan Pencatatan Sipil',
    },
    {
      'title': 'Diskominfo',
      'image': 'assets/images/diskominfo.png',
      'icon': Icons.hub_rounded,
      'desc': 'Dinas Komunikasi dan Informatika',
    },
    {
      'title': 'Dinkes',
      'image': 'assets/images/dinkes.png',
      'icon': Icons.health_and_safety_rounded,
      'desc': 'Pelayanan Kesehatan Masyarakat',
    },
    {
      'title': 'Disdikbud',
      'image': 'assets/images/disdikbud.png',
      'icon': Icons.school_rounded,
      'desc': 'Dinas Pendidikan dan Kebudayaan',
    },
    {
      'title': 'DPMPTSP',
      'image': 'assets/images/dpmptsp.png',
      'icon': Icons.assignment_rounded,
      'desc': 'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
    },
    {
      'title': 'DKP3',
      'image': 'assets/images/dkp3.png',
      'icon': Icons.eco_rounded,
      'desc': 'Dinas Ketahanan Pangan, Pertanian dan Perikanan',
    },
    {
      'title': 'BPKPD',
      'image': 'assets/images/bpkpd.png',
      'icon': Icons.account_balance_wallet_rounded,
      'desc': 'Badan Pengelola Keuangan dan Pendapatan Daerah',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Background utama PUTIH / Off-White
      appBar: AppBar(
        backgroundColor: const Color(0xFF123457), // AppBar Navy
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Instansi Kota Sukabumi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _instansiList.length,
        itemBuilder: (context, index) {
          final item = _instansiList[index];
          final String? imagePath = item['image'] as String?;
          final IconData iconData = item['icon'] as IconData? ?? Icons.account_balance_rounded;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF123457), // Shape Box Berwarna NAVY
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA5A4A4), width: 0.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white, // Box Ikon Putih di dalam Kartu Navy
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFAC33), width: 1.5),
                ),
                child: imagePath != null
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            iconData,
                            color: const Color(0xFF123457),
                            size: 32,
                          );
                        },
                      )
                    : Icon(
                        iconData,
                        color: const Color(0xFF123457),
                        size: 32,
                      ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  item['desc'] as String,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Color(0xFFE8A33D),
              ),
              onTap: () {
                if (item['title'] == 'Disdukcapil') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoDisdukcapil(),
                    ),
                  );
                } else if (item['title'] == 'Diskominfo') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoDiskominfo(),
                    ),
                  );
                } else if (item['title'] == 'DPMPTSP') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoDpmpstp(),
                    ),
                  );
                } else if (item['title'] == 'DKP3') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoDkp3(),
                    ),
                  );
                } else if (item['title'] == 'BPKPD') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoBpkpd(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Informasi ${item['title']} belum tersedia'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
