import 'package:flutter/material.dart';
import 'smart_image.dart';

class AdminImagePicker extends StatefulWidget {
  final String currentImagePath;
  final ValueChanged<String> onImageSelected;
  final String label;

  const AdminImagePicker({
    super.key,
    required this.currentImagePath,
    required this.onImageSelected,
    this.label = 'Logo / Foto Instansi',
  });

  @override
  State<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends State<AdminImagePicker> {
  late String _selectedPath;

  final List<Map<String, String>> _presetLogos = const [
    {'title': 'Disdukcapil Logo', 'path': 'assets/images/disduk.png'},
    {'title': 'Diskominfo Logo', 'path': 'assets/images/diskominfo.png'},
    {'title': 'DPMPTSP Logo', 'path': 'assets/images/dpmptsp.png'},
    {'title': 'BPKPD Logo', 'path': 'assets/images/bpkpd.png'},
    {'title': 'DKP3 Logo', 'path': 'assets/images/dkp3.png'},
    {'title': 'Sektor Keluarga', 'path': 'assets/icon/keluarga.png'},
    {'title': 'Sektor Pendidikan', 'path': 'assets/icon/pendidikan.png'},
    {'title': 'Sektor Usaha', 'path': 'assets/icon/usaha.png'},
    {'title': 'Sektor Lingkungan', 'path': 'assets/icon/lingkungan.png'},
    {'title': 'Sektor Kendaraan', 'path': 'assets/icon/kendaraan.png'},
    {'title': 'Sektor Kesehatan', 'path': 'assets/icon/kesehatan.png'},
    {'title': 'Sektor Tanggap Darurat', 'path': 'assets/icon/tanggapdarurat.png'},
    {'title': 'Sektor Karier', 'path': 'assets/icon/karier.png'},
    {'title': 'Sektor Rekreasi', 'path': 'assets/icon/rekreasi.png'},
    {'title': 'Sektor Sosial Hukum', 'path': 'assets/icon/sosialhukum.png'},
  ];

  final List<Map<String, String>> _galleryPhotos = const [
    {'title': 'Logo Utama Sukabumi', 'path': 'assets/images/logo.png', 'date': 'Hari ini, 10:15'},
    {'title': 'Dokumen Diskominfo', 'path': 'assets/images/diskominfo.png', 'date': 'Kemarin, 14:20'},
    {'title': 'Berkas Disdukcapil', 'path': 'assets/images/disduk.png', 'date': '02 Ags 2026'},
    {'title': 'Berkas DPMPTSP', 'path': 'assets/images/dpmptsp.png', 'date': '01 Ags 2026'},
    {'title': 'Foto Layanan Usaha', 'path': 'assets/icon/usaha.png', 'date': '30 Jul 2026'},
    {'title': 'Foto Tanggap Darurat', 'path': 'assets/icon/tanggapdarurat.png', 'date': '28 Jul 2026'},
  ];

  final List<Map<String, String>> _fileManagerDocs = const [
    {'name': 'IMG_20260804_CAPTURE.png', 'size': '1.2 MB', 'path': 'assets/images/logo.png', 'type': 'PNG Image'},
    {'name': 'berkas_persyaratan_layanan.jpg', 'size': '850 KB', 'path': 'assets/images/disduk.png', 'type': 'JPG Image'},
    {'name': 'logo_instansi_resmi.png', 'size': '512 KB', 'path': 'assets/images/diskominfo.png', 'type': 'PNG Image'},
    {'name': 'surat_keputusan_opd.png', 'size': '1.8 MB', 'path': 'assets/images/dpmptsp.png', 'type': 'PNG Image'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.currentImagePath;
  }

  @override
  void didUpdateWidget(covariant AdminImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentImagePath != oldWidget.currentImagePath) {
      setState(() {
        _selectedPath = widget.currentImagePath;
      });
    }
  }

  void _pilihDanSimpanPath(String sumber, String chosenPath) {
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _selectedPath = chosenPath;
    });
    widget.onImageSelected(_selectedPath);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Foto berhasil dipilih dari $sumber!',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF123457),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 1. DIALOG INTERAKTIF KAMERA (AMBIL FOTO LANGSUNG)
  void _bukaKameraDialog() {
    Navigator.pop(context); // Tutup main modal

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Color(0xFF123457)),
                    SizedBox(width: 10),
                    Text(
                      'Kamera HP',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123457),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                const SizedBox(height: 6),

                // CAMERA VIEWFINDER BOX
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8A33D), width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SmartImage(
                        imagePath: 'assets/icon/camera.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Kamera Siap • Ketuk Tombol Jepret',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // TOMBOL SHUTTER KAMERA
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pilihDanSimpanPath('Kamera HP', 'assets/icon/camera.png');
                    },
                    icon: const Icon(Icons.circle_notifications_rounded, size: 24),
                    label: const Text(
                      '📸 Jepret Foto Sekarang',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123457),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. MODAL GRID ALBUM GALERI FOTO
  void _bukaGaleriModal() {
    Navigator.pop(context); // Tutup main modal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.photo_library_rounded, color: Color(0xFFE8A33D)),
                      SizedBox(width: 10),
                      Text(
                        'Galeri Foto HP',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123457),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 12),

              const Text(
                'Pilih foto dari Album Galeri Perangkat Anda:',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _galleryPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final photo = _galleryPhotos[index];
                  final bool isSelected = _selectedPath == photo['path'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pilihDanSimpanPath('Galeri Foto', photo['path']!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFE8A33D) : Colors.grey.shade300,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmartImage(
                            imagePath: photo['path']!,
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            photo['title']!,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF123457),
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            photo['date']!,
                            style: const TextStyle(fontSize: 8.5, color: Colors.grey, fontFamily: 'Poppins'),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  // 3. MODAL PENJELAJAH BERKAS FILE MANAGER
  void _bukaFileManagerModal() {
    Navigator.pop(context); // Tutup main modal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.folder_open_rounded, color: Color(0xFF008080)),
                      SizedBox(width: 10),
                      Text(
                        'Pengelola Berkas (File Manager)',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123457),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 12),

              const Text(
                'Pilih berkas gambar/dokumen dari penyimpanan internal:',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 14),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fileManagerDocs.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  final doc = _fileManagerDocs[index];
                  final bool isSelected = _selectedPath == doc['path'];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008080).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF008080), size: 24),
                    ),
                    title: Text(
                      doc['name']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFFE8A33D) : const Color(0xFF123457),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    subtitle: Text(
                      '${doc['type']} • ${doc['size']}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _pilihDanSimpanPath('File Manager', doc['path']!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF123457),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Pilih', style: TextStyle(fontSize: 11, fontFamily: 'Poppins')),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  void _bukaModalPilihGambar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pilih / Unggah ${widget.label}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123457),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // OPSI UTAMA INTERAKTIF: KAMERA, GALERI, FILE MANAGER
              const Text(
                'Pilih Sumber Unggah Foto:',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123457),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // 1. KAMERA (INTERAKTIF)
                  Expanded(
                    child: _buildSourceCard(
                      icon: Icons.photo_camera_rounded,
                      title: 'Kamera',
                      subtitle: 'Ambil Foto',
                      color: const Color(0xFF123457),
                      onTap: _bukaKameraDialog,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 2. GALERI FOTO (INTERAKTIF)
                  Expanded(
                    child: _buildSourceCard(
                      icon: Icons.photo_library_rounded,
                      title: 'Galeri',
                      subtitle: 'Pilih Album',
                      color: const Color(0xFFE8A33D),
                      onTap: _bukaGaleriModal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 3. FILE MANAGER (INTERAKTIF)
                  Expanded(
                    child: _buildSourceCard(
                      icon: Icons.folder_open_rounded,
                      title: 'File Manager',
                      subtitle: 'Pilih Berkas',
                      color: const Color(0xFF008080),
                      onTap: _bukaFileManagerModal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // KOLEKSI ASET LOGO RESMI
              const Text(
                'Atau Pilih dari Koleksi Logo Resmi:',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123457),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetLogos.length,
                  itemBuilder: (context, index) {
                    final item = _presetLogos[index];
                    final bool isSelected = _selectedPath == item['path'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPath = item['path']!;
                        });
                        widget.onImageSelected(_selectedPath);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFE8A33D) : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            SmartImage(
                              imagePath: item['path']!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['title']!,
                              style: const TextStyle(fontSize: 9.5, color: Color(0xFF123457), fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.grey.shade700,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: SmartImage(
                  imagePath: _selectedPath,
                  width: 46,
                  height: 46,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedPath.isNotEmpty ? _selectedPath : 'Belum ada gambar terpilih',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Klik tombol di kanan untuk memilih atau mengunggah logo baru.',
                      style: TextStyle(fontSize: 10.5, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _bukaModalPilihGambar,
                icon: const Icon(Icons.photo_camera_rounded, size: 16),
                label: const Text('Unggah / Pilih', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
