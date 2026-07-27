  import 'package:flutter/material.dart';
import 'service_form_screen.dart';

class DukcapilServicesScreen extends StatelessWidget {
  const DukcapilServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Disdukcapil'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Banner Pengantar
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A1E33), Color(0xFF123457)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8A33D), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Jenis Pengajuan Kependudukan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Silakan pilih kategori dan jenis dokumen kependudukan yang ingin Anda ajukan di bawah ini.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Kategori 1: E-KTP
            _buildCategoryCard(
              context,
              title: 'E-KTP (Kartu Tanda Penduduk)',
              icon: Icons.contact_mail,
              subservices: [
                {'name': 'KTP Hilang', 'endpoint': 'disdukcapil/ktp/hilang', 'type': 'hilang'},
                {'name': 'KTP Rusak', 'endpoint': 'disdukcapil/ktp/rusak', 'type': 'rusak'},
                {'name': 'KTP Pindah Domicile', 'endpoint': 'disdukcapil/ktp/pindah', 'type': 'pindah'},
                {'name': 'KTP Ubah Elemen Data', 'endpoint': 'disdukcapil/ktp/ubah', 'type': 'ubah'},
              ],
            ),

            // Kategori 2: Kartu Keluarga
            _buildCategoryCard(
              context,
              title: 'Kartu Keluarga (KK)',
              icon: Icons.people,
              subservices: [
                {'name': 'KK Baru', 'endpoint': 'disdukcapil/kk/baru', 'type': 'kk_baru'},
                {'name': 'KK Pisah (Pecah KK)', 'endpoint': 'disdukcapil/kk/pisah', 'type': 'kk_pisah'},
                {'name': 'KK Hilang', 'endpoint': 'disdukcapil/kk/hilang', 'type': 'kk_hilang'},
                {'name': 'KK Rusak', 'endpoint': 'disdukcapil/kk/rusak', 'type': 'kk_rusak'},
                {'name': 'KK Numpang/Gabung', 'endpoint': 'disdukcapil/kk/numpang', 'type': 'kk_numpang'},
              ],
            ),

            // Kategori 3: KIA
            _buildCategoryCard(
              context,
              title: 'KIA (Kartu Identitas Anak)',
              icon: Icons.child_care,
              subservices: [
                {'name': 'KIA Baru', 'endpoint': 'disdukcapil/kia/baru', 'type': 'kia_baru'},
                {'name': 'KIA Hilang', 'endpoint': 'disdukcapil/kia/hilang', 'type': 'kia_hilang'},
                {'name': 'KIA Rusak', 'endpoint': 'disdukcapil/kia/rusak', 'type': 'kia_rusak'},
              ],
            ),

            // Kategori 4: Surat Pindah
            _buildCategoryCard(
              context,
              title: 'Surat Keterangan Pindah',
              icon: Icons.compare_arrows,
              subservices: [
                {'name': 'Pindah Domisili Dalam Kota', 'endpoint': 'disdukcapil/pindah/dalam', 'type': 'pindah_dalam'},
                {'name': 'Pindah Domisili Keluar Kota', 'endpoint': 'disdukcapil/pindah/keluar', 'type': 'pindah_keluar'},
                {'name': 'Pindah Domisili Datang', 'endpoint': 'disdukcapil/pindah/datang', 'type': 'pindah_datang'},
              ],
            ),

            // Kategori 5: Akta Kelahiran
            _buildCategoryCard(
              context,
              title: 'Akta Kelahiran',
              icon: Icons.child_friendly,
              subservices: [
                {'name': 'Akta Baru', 'endpoint': 'disdukcapil/akta-kelahiran/baru', 'type': 'akta_baru'},
                {'name': 'Akta Hilang', 'endpoint': 'disdukcapil/akta-kelahiran/hilang', 'type': 'akta_hilang'},
                {'name': 'Akta Rusak', 'endpoint': 'disdukcapil/akta-kelahiran/rusak', 'type': 'akta_rusak'},
              ],
            ),

            // Kategori 6: Akta Kematian
            _buildCategoryCard(
              context,
              title: 'Akta Kematian',
              icon: Icons.sentiment_very_dissatisfied,
              subservices: [
                {'name': 'Akta Kematian Baru', 'endpoint': 'disdukcapil/akta-kematian/baru', 'type': 'kematian_baru'},
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Map<String, String>> subservices,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF123457)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        iconColor: const Color(0xFFE8A33D),
        children: subservices.map((sub) {
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 72, right: 20),
            title: Text(
              sub['name']!,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceFormScreen(
                    serviceName: sub['name']!,
                    endpoint: sub['endpoint']!,
                    serviceType: sub['type']!,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
