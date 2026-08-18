import 'package:flutter/material.dart';
import 'package:mobile/models/custom_field_config.dart';
import 'package:mobile/models/layanan_model.dart';
import 'package:mobile/services/opd_service.dart';
import '../berita_dan_fitur/mitra_webview_screen.dart';
import 'package:mobile/widgets/iframe_preview_widget.dart';

class AdminFormLayananScreen extends StatefulWidget {
  final LayananModel? layanan;
  final bool isIframeMode;

  const AdminFormLayananScreen({super.key, this.layanan, this.isIframeMode = false});

  @override
  State<AdminFormLayananScreen> createState() => _AdminFormLayananScreenState();
}

class _AdminFormLayananScreenState extends State<AdminFormLayananScreen> {
  final _formKey = GlobalKey<FormState>();
  final OpdService _opdService = OpdService();

  late String _selectedKodeInstansi;
  late String _selectedSektor;
  late TextEditingController _judulLayananController;
  late TextEditingController _rawTitleController;
  late TextEditingController _subjudulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _urlPortalController;

  // FITUR BARU: MODE PENGEDITAN (IFRAME VS MANUAL)
  bool _isIframeMode = false;
  late TextEditingController _iframeUrlController;

  final List<TextEditingController> _persyaratanControllers = [];
  final List<CustomFieldConfig> _formFields = [];

  final List<String> _sektorOptions = const [
    'Keluarga',
    'Usaha',
    'Lingkungan & Tempat Tinggal',
    'Pendidikan',
    'Kendaraan',
    'Kesehatan',
    'Tanggap Darurat',
    'Karier',
    'Rekreasi',
    'Sosial & Hukum',
  ];

  bool get isEdit => widget.layanan != null;

  @override
  void initState() {
    super.initState();
    final item = widget.layanan;

    final allInstansi = _opdService.getInstansiList();
    _selectedKodeInstansi = item?.kodeInstansi ?? (allInstansi.isNotEmpty ? allInstansi.first.kodeInstansi : 'disdukcapil');
    _selectedSektor = item?.sektor ?? _sektorOptions.first;

    _judulLayananController = TextEditingController(text: item?.judulLayanan ?? '');
    _rawTitleController = TextEditingController(text: item?.rawTitle ?? '');
    _subjudulController = TextEditingController(text: item?.subjudul ?? '');
    _deskripsiController = TextEditingController(text: item?.deskripsi ?? '');
    _urlPortalController = TextEditingController(
      text: item?.urlPortal ?? '',
    );

    _isIframeMode = widget.isIframeMode || (item?.isIframeMode ?? false);
    _iframeUrlController = TextEditingController(
      text: item?.iframeUrl.isNotEmpty == true
          ? item!.iframeUrl
          : (item?.urlPortal ?? ''),
    );

    if (item != null) {
      if (item.persyaratan.isNotEmpty) {
        for (var req in item.persyaratan) {
          _persyaratanControllers.add(TextEditingController(text: req));
        }
      }
      if (item.formFields.isNotEmpty) {
        _formFields.addAll(item.formFields);
      } else {
        _initDefaultFormFields();
      }
    } else {
      _persyaratanControllers.add(TextEditingController(text: 'Fotokopi Kartu Keluarga (KK) terbaru.'));
      _persyaratanControllers.add(TextEditingController(text: 'Fotokopi KTP Pemohon.'));
      _initDefaultFormFields();
    }
  }

  void _initDefaultFormFields() {
    _formFields.addAll([
      CustomFieldConfig(id: '1', label: 'NIK Pemohon (16 Digit)', type: FieldType.number, hint: 'Masukkan 16 angka NIK'),
      CustomFieldConfig(id: '2', label: 'Nama Lengkap', type: FieldType.shortText, hint: 'Sesuai KTP / Akta'),
      CustomFieldConfig(id: '3', label: 'Nomor Kartu Keluarga (KK)', type: FieldType.number, hint: 'Masukkan 16 angka No. KK'),
      CustomFieldConfig(id: '4', label: 'Nomor WhatsApp / HP', type: FieldType.number, hint: 'Contoh: 081234567890'),
      CustomFieldConfig(id: '5', label: 'Keterangan / Alasan Permohonan', type: FieldType.longText, hint: 'Jelaskan keperluan permohonan Anda...'),
      CustomFieldConfig(id: '6', label: 'Unggah Dokumen Syarat (JPG, PNG, JPEG)', type: FieldType.fileUpload),
    ]);
  }

  @override
  void dispose() {
    _judulLayananController.dispose();
    _rawTitleController.dispose();
    _subjudulController.dispose();
    _deskripsiController.dispose();
    _urlPortalController.dispose();
    _iframeUrlController.dispose();
    for (var c in _persyaratanControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _tambahPersyaratanRow() {
    setState(() {
      _persyaratanControllers.add(TextEditingController());
    });
  }

  void _hapusPersyaratanRow(int index) {
    if (_persyaratanControllers.length > 1) {
      setState(() {
        _persyaratanControllers[index].dispose();
        _persyaratanControllers.removeAt(index);
      });
    }
  }

  // MODAL DIALOG NOTIFIKASI PENGALIHAN KE IFRAME WEB DINAS
  void _tampilkanNotifBeralihKeIframe(BuildContext context) {
    final urlTarget = _iframeUrlController.text.trim().isNotEmpty
        ? _iframeUrlController.text.trim()
        : (_urlPortalController.text.trim().isNotEmpty
            ? _urlPortalController.text.trim()
            : 'https://disdukcapil.sukabumikota.go.id/form-online');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.code_rounded, color: Color(0xFF0F2942), size: 24),
            SizedBox(width: 10),
            Text(
              'Mode iFrame Web Dinas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF0F2942),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anda telah memilih Mode iFrame Web. Sistem akan membawa dan mengalihkan Anda untuk masuk & melihat tampilan Web iFrame resmi dari Dinas ini:',
              style: TextStyle(fontSize: 12.5, fontFamily: 'Poppins', height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, size: 18, color: Color(0xFF0F2942)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      urlTarget,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2942),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tetap di Pengaturan', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MitraWebviewScreen(
                    judulLayanan: _rawTitleController.text.trim().isNotEmpty
                        ? _rawTitleController.text.trim()
                        : 'Web iFrame Dinas',
                    urlPortal: urlTarget,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
            label: const Text('Masuk ke iFrame Web', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2942),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  void _pilihModeIframe(BuildContext context, {bool closeModalFirst = false}) {
    if (closeModalFirst) {
      Navigator.pop(context);
    }
    setState(() {
      _isIframeMode = true;
    });
    _tampilkanNotifBeralihKeIframe(context);
  }

  // MODAL DIALOG PILIH MODE PENGEDITAN (IFRAME VS MANUAL) SAMA PERSIS GAMBAR USER
  void _bukaModalPilihModeEdit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Mode Pengeditan Form',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2942),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih metode pengisian formulir permohonan warga yang Anda inginkan:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 20),

                // 2 KARTU PILIHAN: IFRAME DAN MANUAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // KARTU 1: IFRAME
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pilihModeIframe(context, closeModalFirst: true),
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isIframeMode ? const Color(0xFFEBF5FF) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isIframeMode ? const Color(0xFF0F2942) : Colors.grey.shade300,
                              width: _isIframeMode ? 2 : 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0E000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F2942).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.code_rounded,
                                  color: Color(0xFF0F2942),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'iframe',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F2942),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // KARTU 2: MANUAL
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isIframeMode = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: !_isIframeMode ? const Color(0xFFEBF5FF) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: !_isIframeMode ? const Color(0xFF0F2942) : Colors.grey.shade300,
                              width: !_isIframeMode ? 2 : 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0E000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F2942).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit_note_rounded,
                                  color: Color(0xFF0F2942),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Manual',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F2942),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // DIALOG FORM BUILDER DENGAN 6 TIPE FIELD
  void _bukaModalTambahAtauEditField({CustomFieldConfig? editField, int? index}) {
    final TextEditingController labelCtrl = TextEditingController(text: editField?.label ?? '');
    final TextEditingController hintCtrl = TextEditingController(text: editField?.hint ?? '');
    FieldType selectedType = editField?.type ?? FieldType.shortText;
    bool isReq = editField?.isRequired ?? true;

    final List<TextEditingController> optionCtrls = [];
    if (editField != null && editField.options.isNotEmpty) {
      for (var opt in editField.options) {
        optionCtrls.add(TextEditingController(text: opt));
      }
    } else {
      optionCtrls.add(TextEditingController(text: 'Pilihan 1'));
      optionCtrls.add(TextEditingController(text: 'Pilihan 2'));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                editField == null ? 'Tambah Element Field Baru' : 'Edit Element Field',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF123457),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Label / Nama Field',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF123457), fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: labelCtrl,
                      style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Tanggal Lahir Anak / Jenis Kelamin',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Tipe Field Input',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF123457), fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<FieldType>(
                          value: selectedType,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF123457), fontFamily: 'Poppins'),
                          items: FieldType.values.map((t) {
                            return DropdownMenuItem(
                              value: t,
                              child: Text(t.displayName),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedType = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (selectedType == FieldType.dropdown) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Opsi Pilihan Dropdown',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF123457), fontFamily: 'Poppins'),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                optionCtrls.add(TextEditingController());
                              });
                            },
                            child: const Text('+ Opsi', style: TextStyle(fontSize: 11, fontFamily: 'Poppins')),
                          ),
                        ],
                      ),
                      ...optionCtrls.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final ctrl = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: ctrl,
                                  style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                                  decoration: InputDecoration(
                                    hintText: 'Opsi ${idx + 1}',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                              ),
                              if (optionCtrls.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    setModalState(() {
                                      optionCtrls[idx].dispose();
                                      optionCtrls.removeAt(idx);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],

                    if (selectedType != FieldType.fileUpload && selectedType != FieldType.datePicker) ...[
                      const Text(
                        'Hint / Teks Petunjuk',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF123457), fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: hintCtrl,
                        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          hintText: 'Contoh: Masukkan data sesuai KTP',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    SwitchListTile(
                      value: isReq,
                      onChanged: (val) => setModalState(() => isReq = val),
                      title: const Text('Wajib Diisi (Required)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (labelCtrl.text.trim().isEmpty) return;

                    final optsList = optionCtrls
                        .map((c) => c.text.trim())
                        .where((t) => t.isNotEmpty)
                        .toList();

                    final newField = CustomFieldConfig(
                      id: editField?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labelCtrl.text.trim(),
                      type: selectedType,
                      isRequired: isReq,
                      options: optsList,
                      hint: hintCtrl.text.trim(),
                    );

                    setState(() {
                      if (index != null) {
                        _formFields[index] = newField;
                      } else {
                        _formFields.add(newField);
                      }
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123457),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan Field', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _simpanLayanan() {
    if (_formKey.currentState!.validate()) {
      final reqList = _persyaratanControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final newModel = LayananModel(
        id: isEdit ? widget.layanan!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        kodeInstansi: _selectedKodeInstansi,
        sektor: _selectedSektor,
        judulLayanan: _judulLayananController.text.trim(),
        rawTitle: _rawTitleController.text.trim().isNotEmpty
            ? _rawTitleController.text.trim()
            : _judulLayananController.text.trim(),
        subjudul: _subjudulController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        persyaratan: reqList,
        urlPortal: _urlPortalController.text.trim(),
        iconName: 'description_outlined',
        isIframeMode: _isIframeMode,
        iframeUrl: _iframeUrlController.text.trim(),
        formFields: _formFields,
      );

      if (isEdit) {
        _opdService.updateLayanan(newModel);
      } else {
        _opdService.addLayanan(newModel);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Layanan "${newModel.rawTitle}" (${_isIframeMode ? "Mode iFrame Web" : "Mode Form Manual"}) berhasil diperbarui!'
                : 'Layanan baru "${newModel.rawTitle}" berhasil ditambahkan!',
          ),
          backgroundColor: const Color(0xFF123457),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final allInstansi = _opdService.getInstansiList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Layanan Publik' : 'Tambah Layanan Publik Baru',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              _buildSectionHeader('Pengelompokan Instansi & Sektor'),
              const SizedBox(height: 12),

              // DROPDOWN INSTANSI
              const Text(
                'Instansi OPD Pengelola',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedKodeInstansi,
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Poppins'),
                    items: allInstansi.map((opd) {
                      return DropdownMenuItem(
                        value: opd.kodeInstansi,
                        child: Text('${opd.namaSingkat} - ${opd.namaLengkap}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedKodeInstansi = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // DROPDOWN SEKTOR FASE KEHIDUPAN
              const Text(
                'Sektor Kategori Layanan',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _opdService.getSektorList().any((s) => s.title == _selectedSektor)
                        ? _selectedSektor
                        : (_opdService.getSektorList().isNotEmpty ? _opdService.getSektorList().first.title : 'Keluarga'),
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Poppins'),
                    items: _opdService.getSektorList().map((s) {
                      return DropdownMenuItem(
                        value: s.title,
                        child: Text('Sektor ${s.title}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSektor = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionHeader('Detail Layanan'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _judulLayananController,
                label: 'Judul Lengkap Layanan',
                hint: 'Contoh: Pelayanan KTP Elektronik (KTP-el)',
                validator: (val) => (val == null || val.isEmpty) ? 'Judul layanan wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _rawTitleController,
                label: 'Nama Ringkas / Singkatan Layanan',
                hint: 'Contoh: KTP Elektronik',
                validator: (val) => (val == null || val.isEmpty) ? 'Nama ringkas wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _subjudulController,
                label: 'Subjudul / Ringkasan Singkat',
                hint: 'Contoh: Perekaman baru, penggantian KTP rusak/hilang...',
                maxLines: 2,
                validator: (val) => (val == null || val.isEmpty) ? 'Subjudul wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _deskripsiController,
                label: 'Deskripsi Lengkap Layanan Publik',
                hint: 'Jelaskan cakupan layanan, sasaran warga, dan manfaat...',
                maxLines: 3,
                validator: (val) => (val == null || val.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _urlPortalController,
                label: 'Link Web Portal Resmi Instansi',
                hint: 'https://disdukcapil.sukabumikota.go.id',
                validator: (val) => (val == null || val.isEmpty) ? 'Link portal wajib diisi' : null,
              ),
              const SizedBox(height: 18),

              // ===============================================================
              // SEKSI LOGIKA DYNAMIC TAMPILAN: MODE IFRAME VS MODE MANUAL
              // ===============================================================
              if (_isIframeMode) ...[
                _buildSectionHeader('Tampilan iFrame Web Portal / Formulir Resmi Dinas'),
                const SizedBox(height: 10),
                const Text(
                  'URL / Link Embed Formulir Web Resmi Dinas:',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _iframeUrlController,
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'https://disdukcapil.sukabumikota.go.id/form-online',
                    prefixIcon: const Icon(Icons.code_rounded, color: primaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    if (_isIframeMode && (val == null || val.trim().isEmpty)) {
                      return 'URL / iFrame Dinas wajib diisi pada Mode iFrame';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // LIVE EMBEDDED IFRAME PREVIEW CONTAINER IN BODY
                IframePreviewWidget(
                  url: _iframeUrlController.text,
                  title: _rawTitleController.text.isNotEmpty
                      ? 'Live iFrame Layanan: ${_rawTitleController.text}'
                      : 'Live iFrame Web Dinas',
                  height: 550,
                ),
                const SizedBox(height: 20),
              ] else ...[
                // SEKSI FORM BUILDER ENGINE DINAMIS MANUAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Form Builder Manual (Elemen Isian Warga)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _bukaModalTambahAtauEditField(),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        '+ Tambah Field',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Admin dapat membuat & mengatur sendiri tipe field (Teks Pendek, Teks Panjang, Dropdown, Kalender, Angka, Upload).',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 10),

                _formFields.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            'Belum ada field formulir. Klik "+ Tambah Field" untuk membuat.',
                            style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ),
                      )
                    : ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _formFields.length,
                        onReorder: (oldIdx, newIdx) {
                          setState(() {
                            if (newIdx > oldIdx) newIdx -= 1;
                            final item = _formFields.removeAt(oldIdx);
                            _formFields.insert(newIdx, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final f = _formFields[index];
                          return Container(
                            key: ValueKey(f.id),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: primaryColor.withOpacity(0.2)),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12),
                                ),
                              ),
                              title: Text(
                                f.label,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
                              ),
                              subtitle: Text(
                                'Tipe: ${f.type.displayName}${f.isRequired ? " • (Wajib)" : " • (Opsional)"}',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontFamily: 'Poppins'),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: primaryColor, size: 20),
                                    onPressed: () => _bukaModalTambahAtauEditField(editField: f, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _formFields.removeAt(index);
                                      });
                                    },
                                  ),
                                  const Icon(Icons.drag_handle_rounded, color: Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
              ],

              // SEKSI SYARAT & DOKUMEN DINAMIS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Persyaratan & Dokumen Syarat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _tambahPersyaratanRow,
                    icon: const Icon(Icons.add_circle_outline_rounded, color: primaryColor, size: 18),
                    label: const Text(
                      'Tambah Syarat',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 4),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _persyaratanControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _persyaratanControllers[index],
                            style: const TextStyle(fontSize: 12.5, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Fotokopi Kartu Keluarga terbaru',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                        if (_persyaratanControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent, size: 22),
                            onPressed: () => _hapusPersyaratanRow(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpanLayanan,
                  icon: const Icon(Icons.save_rounded, color: primaryColor),
                  label: Text(
                    isEdit ? 'Simpan Perubahan Layanan' : 'Tambah Layanan Publik Baru',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: primaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123457),
            fontFamily: 'Poppins',
          ),
        ),
        const Divider(height: 8),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF123457),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF123457), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
