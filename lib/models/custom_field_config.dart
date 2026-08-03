enum FieldType {
  shortText,
  longText,
  dropdown,
  datePicker,
  number,
  fileUpload,
}

extension FieldTypeExtension on FieldType {
  String get displayName {
    switch (this) {
      case FieldType.shortText:
        return 'Teks Pendek (1 Baris)';
      case FieldType.longText:
        return 'Teks Panjang (Paragraf)';
      case FieldType.dropdown:
        return 'Dropdown (Pilihan Ganda)';
      case FieldType.datePicker:
        return 'Kalender (Pilih Tanggal)';
      case FieldType.number:
        return 'Angka / Nomor';
      case FieldType.fileUpload:
        return 'Unggah Dokumen (JPG/PNG/JPEG)';
    }
  }
}

class CustomFieldConfig {
  final String id;
  final String label;
  final FieldType type;
  final bool isRequired;
  final List<String> options; // Opsi jika type == dropdown
  final String hint;

  CustomFieldConfig({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = true,
    this.options = const [],
    this.hint = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'type': type.name,
      'isRequired': isRequired ? 1 : 0,
      'optionsJson': options.join('|||'),
      'hint': hint,
    };
  }

  factory CustomFieldConfig.fromMap(Map<String, dynamic> map) {
    List<String> opts = [];
    if (map['optionsJson'] != null && map['optionsJson'].toString().isNotEmpty) {
      opts = map['optionsJson'].toString().split('|||');
    }

    FieldType fType = FieldType.shortText;
    try {
      final typeStr = map['type']?.toString() ?? 'shortText';
      fType = FieldType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => FieldType.shortText,
      );
    } catch (_) {}

    return CustomFieldConfig(
      id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: map['label']?.toString() ?? '',
      type: fType,
      isRequired: map['isRequired'] == 1 || map['isRequired'] == true,
      options: opts,
      hint: map['hint']?.toString() ?? '',
    );
  }

  CustomFieldConfig copyWith({
    String? id,
    String? label,
    FieldType? type,
    bool? isRequired,
    List<String>? options,
    String? hint,
  }) {
    return CustomFieldConfig(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      hint: hint ?? this.hint,
    );
  }
}
