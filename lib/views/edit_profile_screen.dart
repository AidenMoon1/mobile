import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../widgets/smart_image.dart';
import '../widgets/admin_image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _statusController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final user = _userService.currentUser;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _usernameController = TextEditingController(text: user.username);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _statusController = TextEditingController(text: user.status);
    _dateController = TextEditingController(text: user.joinedDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _statusController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showProfileImageModal(UserModel user) {
    const Color primaryColor = Color(0xFF0A1E33);

    showModalBottomSheet(
      context: context,
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
                  const Text(
                    'Kelola Foto Profil',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
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

              // TOMBOL UNGGAH FOTO BARU
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_camera_rounded, color: primaryColor),
                ),
                title: const Text(
                  'Unggah / Pilih Foto Baru',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                subtitle: const Text(
                  'Pilih foto dari galeri atau aset foto resmi',
                  style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _bukaPickerFoto(user);
                },
              ),

              // TOMBOL HAPUS FOTO PROFIL
              if (user.profileImagePath.isNotEmpty) ...[
                const SizedBox(height: 6),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  ),
                  title: const Text(
                    'Hapus Foto Profil',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: 'Poppins'),
                  ),
                  subtitle: const Text(
                    'Kembalikan foto profil ke avatar default inisial',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    await _userService.removeProfileImage();
                    if (!mounted) return;
                    setState(() {});
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Foto profil berhasil dihapus!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _bukaPickerFoto(UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Avatar / Unggah Foto Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A1E33), fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 12),
              AdminImagePicker(
                label: 'Foto Profil',
                currentImagePath: user.profileImagePath,
                onImageSelected: (path) async {
                  final messenger = ScaffoldMessenger.of(context);
                  final updated = user.copyWith(profileImagePath: path);
                  await _userService.updateProfile(updated);
                  if (!mounted) return;
                  setState(() {});
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Foto profil baru berhasil diperbarui!'),
                      backgroundColor: Color(0xFF123457),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveChanges() {
    final updatedUser = _userService.currentUser.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      username: _usernameController.text,
      phoneNumber: _phoneController.text,
      status: _statusController.text,
    );

    _userService.updateProfile(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan profil berhasil disimpan!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);
    const Color backgroundColor = Colors.white;

    final user = _userService.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.only(top: 50, left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Edit Profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Picture (Floating) dengan interaksi Unggah/Hapus
                Positioned(
                  bottom: -60,
                  child: GestureDetector(
                    onTap: () => _showProfileImageModal(user),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: user.profileImagePath.isNotEmpty
                            ? SmartImage(
                                imagePath: user.profileImagePath,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            // Edit Photo Button
            ElevatedButton.icon(
              onPressed: () => _showProfileImageModal(user),
              icon: const Icon(Icons.photo_camera_rounded, size: 18),
              label: Text(
                user.profileImagePath.isNotEmpty ? 'Ubah / Hapus Foto Profil' : 'Unggah Foto Profil',
                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            const SizedBox(height: 24),

            // Form Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildTextField(label: 'Nama Lengkap', controller: _nameController, icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Alamat Email', controller: _emailController, icon: Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Nama Pengguna (Username)', controller: _usernameController, icon: Icons.alternate_email),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Nomor WhatsApp / HP', controller: _phoneController, icon: Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Status Domisili / Wilayah', controller: _statusController, icon: Icons.location_on_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Terdaftar Sejak', controller: _dateController, icon: Icons.calendar_today_outlined, enabled: false),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    const Color primaryColor = Color(0xFF0A1E33);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey.shade600,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: enabled ? primaryColor : Colors.grey),
            filled: true,
            fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
