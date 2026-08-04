import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layanan/detail_layanan_keluarga.dart';
import '../../services/opd_service.dart';

class InfoDisdukcapil extends StatefulWidget {
  const InfoDisdukcapil({super.key});

  @override
  State<InfoDisdukcapil> createState() => _InfoDisdukcapilState();
}

class _InfoDisdukcapilState extends State<InfoDisdukcapil> {
  bool _isTentangExpanded = true;
  final OpdService _opdService = OpdService();

  @override
  void initState() {
    super.initState();
    _opdService.addListener(_refresh);
  }

  @override
  void dispose() {
    _opdService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _bukaGoogleMaps(String query) async {
    final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka Google Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final opd = _opdService.getInstansiByKode('disdukcapil');
    final layananList = _opdService.getLayananByInstansi('disdukcapil');

    final String namaSingkat = opd?.namaSingkat ?? 'DISDUKCAPIL';
    final String namaLengkap = opd?.namaLengkap ?? 'Dinas Kependudukan dan Pencatatan Sipil';
    final String alamat = opd?.alamat ?? 'Jl. Bhayangkara No. 202, Kota Sukabumi, Jawa Barat';
    final String jamOperasional = opd?.jamOperasional ?? 'Senin - Jumat | 08.00 - 15.30 WIB';
    final String kontak = opd?.kontak ?? '(0266) 221122';
    final String deskripsi = opd?.deskripsi ?? 'Dinas Kependudukan dan Pencatatan Sipil Kota Sukabumi.';
    final List<String> tugasFungsi = opd?.tugasFungsi ?? [
      'Penerbitan KTP-el, KK, KIA.',
      'Pencatatan Akta Kelahiran dan Kematian.',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text(
          'Instansi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU PROFIL UTAMA (HEADER LOGO + NAMA OPD)
            Container(
              width: double.infinity,
              height: 124,
              color: primaryColor,
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: const Alignment(0.4, 0.0),
                        child: Opacity(
                          opacity: 0.22,
                          child: Image.asset(
                            opd?.logoPath ?? 'assets/images/disduk.png',
                            width: 320,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x25000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Image.asset(
                              opd?.logoPath ?? 'assets/images/disduk.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.account_balance_rounded,
                                color: primaryColor,
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaSingkat,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  namaLengkap,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. KARTU INFORMASI ALAMAT, JAM & KONTAK
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Informasi Instansi',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'ALAMAT',
                          content: alamat,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.access_time_rounded,
                          label: 'JAM OPERASIONAL',
                          content: jamOperasional,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          label: 'KONTAK',
                          content: kontak,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. KARTU GOOGLE MAPS PREVIEW
                  GestureDetector(
                    onTap: () => _bukaGoogleMaps(opd?.mapsQuery ?? 'Disdukcapil Kota Sukabumi'),
                    child: Container(
                      width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color(0xFFE5E9EC),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      namaSingkat,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Buka di Maps',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.open_in_new_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 4. SEKSI LAYANAN TERSEDIA (DYNAMIC LIVE STORE)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Layanan Tersedia',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 17.5,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${layananList.length} Layanan',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  layananList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'Belum ada layanan terdaftar pada instansi ini.',
                              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 108,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: layananList.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = layananList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailLayananKeluargaScreen(
                                        judulLayanan: item.rawTitle,
                                        subjudul: item.subjudul,
                                        deskripsiTentang: item.deskripsi,
                                        persyaratan: item.persyaratan,
                                        layananModel: item,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 92,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade300, width: 1.3),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0C000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 46,
                                        height: 46,
                                        decoration: const BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.description_outlined,
                                          color: accentColor,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.rawTitle,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          height: 1.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                  const SizedBox(height: 24),

                  // 5. ACCORDION TENTANG DISDUKCAPIL
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: _isTentangExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() => _isTentangExpanded = expanded);
                        },
                        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        iconColor: accentColor,
                        collapsedIconColor: primaryColor,
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.business_rounded,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tentang $namaSingkat',
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                                const SizedBox(height: 12),
                                Text(
                                  deskripsi,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    height: 1.6,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Tugas & Fungsi Utama:',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...tugasFungsi.map(
                                  (tf) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ',
                                            style: TextStyle(
                                                color: accentColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                            tf,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12.5,
                                              height: 1.4,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String content,
  }) {
    const Color primaryColor = Color(0xFF123457);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
