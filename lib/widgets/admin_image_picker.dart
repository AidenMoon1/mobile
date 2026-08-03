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
  final TextEditingController _customUrlController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.currentImagePath;
    _customUrlController.text = _selectedPath;
  }

  @override
  void didUpdateWidget(covariant AdminImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentImagePath != oldWidget.currentImagePath) {
      setState(() {
        _selectedPath = widget.currentImagePath;
        _customUrlController.text = _selectedPath;
      });
    }
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    super.dispose();
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
                  Text(
                    'Pilih / Unggah ${widget.label}',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123457),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // OPSI 1: KOLEKSI ASSET LOGO RESMI
              const Text(
                'Pilih dari Koleksi Aset Logo Resmi:',
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
                          _customUrlController.text = _selectedPath;
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
              const Divider(height: 1),
              const SizedBox(height: 14),

              // OPSI 2: UNGGAH / INPUT JALUR BERKAS CUSTOM (FILE PATH / LINK URL)
              const Text(
                'Atau Masukkan Link URL / Path Gambar Baru:',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123457),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customUrlController,
                      style: const TextStyle(fontSize: 12.5, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: 'https://domain.com/logo.png atau file_path',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final text = _customUrlController.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          _selectedPath = text;
                        });
                        widget.onImageSelected(_selectedPath);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123457),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Terapkan', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
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
