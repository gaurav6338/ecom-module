import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? 'Rishi Kumar');
    _emailController = TextEditingController(text: user?.email ?? 'rishi@gmail.com');
    _phoneController = TextEditingController(text: user?.phone ?? '+91 98765 43210');
    _addressController = TextEditingController(
      text: user?.address ?? '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id ?? 'user_rishi_01';

    final updatedUser = await userProvider.updateUserProfile(
      userId: userId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (updatedUser != null) {
      await authProvider.updateCurrentUser(updatedUser);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        user?.avatarUrl ??
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Avatar image update ready')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                validator: (val) => val == null || val.isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                readOnly: true, // Email locked for primary demo account
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                validator: (val) => val == null || val.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: 'Primary Address',
                controller: _addressController,
                maxLines: 3,
                prefixIcon: Icons.location_on_outlined,
                validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
