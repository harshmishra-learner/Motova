import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/overflow_menu_button.dart';
import '../../../shared/widgets/primary_button.dart';

/// TODO(Day 16): prefill from real user data via AuthRepository,
/// wire Save Changes (and avatar upload) to real API calls.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Benjamin');
  final _lastNameController = TextEditingController(text: 'Jack');
  final _emailController = TextEditingController(text: 'benjaminJack@gmail.com');
  final _phoneController = TextEditingController(text: '+100******00');

  bool _isLoading = false;
  File? _pickedAvatar;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile == null) return; // user cancelled the picker
      if (!mounted) return;

      setState(() => _pickedAvatar = File(pickedFile.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open photo library. Please try again.")),
      );
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO(Day 16): replace with real update-profile API call,
    // including uploading _pickedAvatar if it's not null.
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (context.canPop()) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: AppDimensions.backButtonSize,
            height: AppDimensions.backButtonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16),
          ),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text('Edit Profile'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppDimensions.space16),
            child: OverflowMenuButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.space24),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: AppDimensions.avatarSizeLarge,
                      height: AppDimensions.avatarSizeLarge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.iconCircleBackground,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _pickedAvatar != null
                          ? Image.file(_pickedAvatar!, fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images/avatar_placeholder.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: AppDimensions.avatarSizeLarge * 0.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: InkWell(
                        onTap: _pickAvatar,
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: const Icon(Icons.edit_outlined, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.space16),

                Text(
                  '${_firstNameController.text} ${_lastNameController.text}',
                  style: AppTextStyles.sectionTitle,
                ),

                const SizedBox(height: AppDimensions.space24),

                AppTextField(
                  hintText: 'First Name',
                  controller: _firstNameController,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'First name is required' : null,
                ),

                const SizedBox(height: AppDimensions.space16),

                AppTextField(
                  hintText: 'Last Name',
                  controller: _lastNameController,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Last name is required' : null,
                ),

                const SizedBox(height: AppDimensions.space16),

                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Email is required' : null,
                ),

                const SizedBox(height: AppDimensions.space16),

                AppTextField(
                  hintText: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: AppDimensions.space32),

                PrimaryButton(
                  text: 'Save Changes',
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),

                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}