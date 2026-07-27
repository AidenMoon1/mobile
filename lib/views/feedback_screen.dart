import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  
  // State untuk form
  int? _selectedRating;
  String? _selectedGender = 'Pria';
  String? _selectedFactor;
  String? _selectedEducation;
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _factors = [
    'Kecepatan Layanan',
    'Kemudahan Penggunaan',
    'Kelengkapan Fitur',
    'Desain Antarmuka',
    'Kestabilan Aplikasi'
  ];

  final List<String> _educations = [
    'SD / Sederajat',
    'SMP / Sederajat',
    'SMA / SMK / Sederajat',
    'Diploma (D1/D2/D3)',
    'Sarjana (S1)',
    'Magister (S2)',
    'Doktor (S3)'
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_selectedRating == null || _selectedFactor == null || _selectedEducation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua bidang bertanda *'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Simpan ke service
    final newFeedback = FeedbackModel(
      rating: _selectedRating!,
      factor: _selectedFactor!,
      reason: _reasonController.text,
      gender: _selectedGender!,
      education: _selectedEducation!,
      date: DateTime.now(),
    );

    _feedbackService.addFeedback(newFeedback);

    // Reset Form
    setState(() {
      _selectedRating = null;
      _selectedFactor = null;
      _selectedEducation = null;
      _reasonController.clear();
    });

    // Feedback Sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kritik dan saran Anda telah terkirim!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Pindah ke tab riwayat (Tab Index 1)
    DefaultTabController.of(context).animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FB),
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: accentColor, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          title: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Kritik ', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'dan Saran', style: TextStyle(color: accentColor)),
              ],
            ),
          ),
          bottom: const TabBar(
            indicatorColor: accentColor,
            labelColor: accentColor,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Formulir'),
              Tab(text: 'Riwayat'),
            ],
          ),
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            _buildFormTab(primaryColor, accentColor),
            _buildHistoryTab(primaryColor, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTab(Color primaryColor, Color accentColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Terima kasih!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Pendapat Anda sangat berarti untuk meningkatkan layanan Sukabumi One Access',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feedback Section
          _buildSectionCard(
            title: 'Feedback Layanan',
            primaryColor: primaryColor,
            accentColor: accentColor,
            children: [
              _buildQuestionText('1. Bagaimana penilaian Anda terhadap aplikasi Sukabumi City One Access? *'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildRatingBox(index + 1, accentColor)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Sangat Tidak Puas', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text('Sangat Puas', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 20),
              _buildQuestionText('2. Faktor apa saja yang perlu ditingkatkan? *'),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Pilih faktor yang relevan',
                items: _factors,
                value: _selectedFactor,
                onChanged: (val) => setState(() => _selectedFactor = val),
              ),
              const SizedBox(height: 20),
              _buildQuestionText('3. Mengapa hal tersebut perlu ditingkatkan?'),
              const SizedBox(height: 8),
              _buildTextArea('Masukkan alasan Anda di sini...', _reasonController),
            ],
          ),
          const SizedBox(height: 20),

          // User Data Section
          _buildSectionCard(
            title: 'Data Pengguna',
            primaryColor: primaryColor,
            accentColor: accentColor,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Perubahan pada bagian ini juga akan mengubah data di bagian profil Anda.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
              _buildQuestionText('Jenis Kelamin *'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildGenderOption('Pria', accentColor),
                  const SizedBox(width: 16),
                  _buildGenderOption('Wanita', accentColor),
                ],
              ),
              const SizedBox(height: 20),
              _buildQuestionText('Pendidikan Akhir *'),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Pilih Pendidikan Akhir',
                items: _educations,
                value: _selectedEducation,
                onChanged: (val) => setState(() => _selectedEducation = val),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Terima kasih atas penilaiannya. Dengan Mengisi Ini, Anda Menyetujui data yang diberikan digunakan untuk pengembangan layanan.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 20),
          
          // Submit Button
          GestureDetector(
            onTap: _submitFeedback,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Kirim Masukan',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color primaryColor,
    required Color accentColor,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildQuestionText(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
        children: [
          TextSpan(text: text.replaceAll('*', '')),
          if (text.contains('*'))
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildRatingBox(int value, Color accentColor) {
    bool isSelected = _selectedRating == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRating = value),
      child: Container(
        width: 65,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? accentColor : Colors.black12),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? accentColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: isSelected 
          ? Icon(Icons.star, color: accentColor) 
          : Text('$value', style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint, 
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }

  Widget _buildTextArea(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, Color accentColor) {
    bool isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? accentColor : Colors.black12),
            borderRadius: BorderRadius.circular(25),
            color: isSelected ? accentColor.withOpacity(0.05) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(Color primaryColor, Color accentColor) {
    final history = _feedbackService.history;

    if (history.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat masukan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final String formattedDate = DateFormat('dd MMMM yyyy').format(item.date);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Terkirim',
                      style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Feedback: ${item.factor}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                item.reason.isEmpty ? '(Tanpa alasan detail)' : item.reason,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Rating: ${item.rating}/4',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
