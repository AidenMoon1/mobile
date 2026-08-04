import 'package:flutter/material.dart';

class TermsAndPolicyScreen extends StatefulWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  State<TermsAndPolicyScreen> createState() => _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends State<TermsAndPolicyScreen> {
  // Map status ekspansi accordion (Dasar Hukum default true)
  final Map<String, bool> _expandedMap = {
    'Dasar Hukum': true,
    'Data Pribadi Pengguna': false,
    'Data Non-Pribadi Pengguna': false,
    'Cookies': false,
    'Bagaimana Kami Menggunakan Data': false,
    'Perlindungan Data Pribadi Pengguna': false,
    'Berbagi Data Pribadi Dan Data Non-Pribadi': false,
    'Jangka Waktu Data': false,
    'Perubahan Kebijakan Privasi': false,
    'Persetujuan': false,
  };

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: accentColor, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            children: [
              TextSpan(text: 'Kebijakan ', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'dan Ketentuan', style: TextStyle(color: accentColor)),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // TITLE KEBIJAKAN PRIVASI
              const Text(
                'KEBIJAKAN PRIVASI',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 14),

              // VERSION BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Versi 5.4.3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // UPDATE DATE ROW
              const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: primaryColor, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Diperbarui per tanggal ',
                    style: TextStyle(color: Colors.grey, fontSize: 12.5, fontFamily: 'Poppins'),
                  ),
                  Text(
                    '23 Desember 2026',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // INTRO PARAGRAPH
              const Text(
                'Kebijakan Privasi ini menjelaskan bagaimana Sukabumi City One Access mengumpulkan, menggunakan, menyimpan, dan melindungi data pribadi Anda selama menggunakan layanan aplikasi. Informasi yang Anda berikan akan digunakan untuk mendukung penyelenggaraan layanan, meningkatkan kualitas pelayanan, serta memberikan pengalaman penggunaan aplikasi yang lebih baik sesuai dengan ketentuan yang berlaku.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.55,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              // LIST SECTION ACCORDION
              _buildAccordionItem(
                title: 'Dasar Hukum',
                contentWidget: _buildDasarHukumContent(),
              ),
              _buildAccordionItem(
                title: 'Data Pribadi Pengguna',
                contentWidget: const Text(
                  'Data pribadi yang dikumpulkan meliputi Nama Lengkap, NIK, Nomor Kartu Keluarga, Alamat Email, Nomor WhatsApp, dan Data Geopolitik Domisili untuk keperluan verifikasi layanan publik.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Data Non-Pribadi Pengguna',
                contentWidget: const Text(
                  'Data non-pribadi mencakup statistik penggunaan aplikasi, tipe perangkat HP, versi sistem operasi, dan log performa anonim untuk peningkatan kualitas sistem.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Cookies',
                contentWidget: const Text(
                  'Aplikasi menggunakan identifikasi sesi lokal (Shared Preferences) untuk menyimpan preferensi akun dan data otentikasi agar Anda tidak perlu login berulang kali.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Bagaimana Kami Menggunakan Data',
                contentWidget: const Text(
                  'Data digunakan secara khusus untuk pemrosesan permohonan perizinan, penerbitan dokumen kependudukan, validasi NIK/KK terpadu, serta pengiriman notifikasi status pengajuan.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Perlindungan Data Pribadi Pengguna',
                contentWidget: const Text(
                  'Seluruh data terenkripsi menggunakan protokol SSL/TLS 256-bit dan disimpan pada server teraman Pemkot Sukabumi sesuai standar keamanan ISO/IEC 27001.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Berbagi Data Pribadi Dan Data Non-Pribadi',
                contentWidget: const Text(
                  'Data hanya dibagikan secara resmi antar instansi OPD Kota Sukabumi yang berwenang dalam memproses layanan publik Anda dan tidak pernah diperjualbelikan kepada pihak ketiga.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Jangka Waktu Data',
                contentWidget: const Text(
                  'Data pribadi disimpan selama akun aktif atau sesuai jangka waktu retensi dokumen publik yang diatur dalam perundang-undangan kearsipan daerah.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Perubahan Kebijakan Privasi',
                contentWidget: const Text(
                  'Perubahan atas kebijakan privasi akan diumumkan melalui pembaruan versi aplikasi dan notifikasi resmi sebelum perubahan diberlakukan.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),
              _buildAccordionItem(
                title: 'Persetujuan',
                contentWidget: const Text(
                  'Dengan mengunduh dan menggunakan aplikasi Sukabumi One Access, Anda menyatakan menyetujui seluruh ketentuan dalam Kebijakan Privasi ini.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordionItem({
    required String title,
    required Widget contentWidget,
  }) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    final bool isExpanded = _expandedMap[title] ?? false;

    return Column(
      children: [
        const Divider(height: 1, color: Colors.black12),
        InkWell(
          onTap: () {
            setState(() {
              _expandedMap[title] = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: isExpanded ? accentColor : primaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isExpanded ? accentColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.chevron_right_rounded,
                    color: isExpanded ? Colors.white : Colors.grey.shade600,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 4.0),
            child: contentWidget,
          ),
      ],
    );
  }

  Widget _buildDasarHukumContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pemrosesan data pribadi pada Aplikasi dilaksanakan sesuai peraturan perundang-undangan yang berlaku, termasuk Undang-Undang Nomor 27 Tahun 2022 tentang Perlindungan Data Pribadi (UU PDP). Bergantung pada tujuan pemrosesan, Kami menggunakan satu atau lebih dasar hukum berikut, yang diterapkan secara proporsional dan terdokumentasi:',
          style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 10),

        _buildNumberedPoint(
          number: '1.',
          title: 'Persetujuan (Consent). ',
          text: 'Pemrosesan dilakukan berdasarkan persetujuan yang jelas dan aktif dari Anda. Persetujuan dapat ditarik sewaktu-waktu tanpa mempengaruhi keabsahan pemrosesan sebelum penarikan.',
        ),
        _buildNumberedPoint(
          number: '2.',
          title: 'Kewajiban Hukum. ',
          text: 'Pemrosesan diperlukan untuk memenuhi kewajiban hukum yang mengikat Kami sesuai ketentuan peraturan perundang-undangan yang berlaku.',
        ),
        _buildNumberedPoint(
          number: '3.',
          title: 'Kepentingan Umum dalam Rangka Penyelenggaraan Negara. ',
          text: 'Pemrosesan diperlukan penyelenggaraan pelayanan publik dan/atau pelaksanaan tugas pemerintahan yang sah, termasuk verifikasi identitas menggunakan NIK dan/atau Nomor KK melalui sistem/penyedia resmi yang berwenang serta pertukaran data yang diperlukan dengan instansi terkait.',
        ),
        _buildNumberedPoint(
          number: '4.',
          title: 'Pelaksanaan Perjanjian. ',
          text: 'Pemrosesan diperlukan untuk memenuhi dan/atau mengeksekusi perjanjian antara Anda dan Kami, termasuk penyediaan fitur dan layanan.',
        ),
        _buildNumberedPoint(
          number: '5.',
          title: 'Kepentingan yang Sah (Legitimate Interests). ',
          text: 'Pemrosesan diperlukan untuk kepentingan yang sah dari Kami dan/atau pihak ketiga, sepanjang tidak mengesampingkan hak dan kebebasan Anda.',
        ),

        const SizedBox(height: 10),
        const Text(
          'Dasar hukum dapat berbeda antar tujuan pemrosesan dan tidak saling meniadakan. Untuk setiap tujuan, Kami menentukan dasar hukum yang paling tepat (misalnya penyelenggaraan negara/kewajiban hukum untuk verifikasi NIK/KK; persetujuan untuk pemrosesan opsional seperti personalisasi/analitik non-esensial), dan melakukan pencatatan internal atas dasar hukum yang digunakan beserta versi kebijakan yang berlaku pada saat pemrosesan dilakukan. Apabila di kemudian hari terdapat perubahan material pada tujuan atau ruang lingkup pemrosesan yang berbasis persetujuan, Kami akan meminta persetujuan ulang sesuai ketentuan yang berlaku.',
          style: TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.5, fontFamily: 'Poppins'),
        ),
      ],
    );
  }

  Widget _buildNumberedPoint({
    required String number,
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A1E33),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1E33),
                      fontSize: 12.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12.5,
                      height: 1.45,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
