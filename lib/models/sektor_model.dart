class SektorModel {
  final String id;
  final String title;
  final String imagePath;
  final String desc;
  final String iconName;

  SektorModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.desc,
    required this.iconName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'desc': desc,
      'iconName': iconName,
    };
  }

  factory SektorModel.fromMap(Map<String, dynamic> map) {
    return SektorModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? 'assets/icon/keluarga.png',
      desc: map['desc']?.toString() ?? '',
      iconName: map['iconName']?.toString() ?? 'category',
    );
  }

  SektorModel copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? desc,
    String? iconName,
  }) {
    return SektorModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      desc: desc ?? this.desc,
      iconName: iconName ?? this.iconName,
    );
  }
}
